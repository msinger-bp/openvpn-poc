require 'faraday'
require 'json'
require 'timeout'

### Create a ohai hints file at /etc/chef/ohai/hints/terraform.json like:
### { "tfstate_s3_url": "s3://bucket/path/state.tfstate" }

DDB_TIMEOUT=3600
DDB_INTERVAL=15

Ohai.plugin(:TerraformState) do
  provides 'terraform'

  def wait_for_ddb_lock()
    if hint?('terraform-nowait') # skip sync code
      puts "terraform-nowait.json ohai hint found, skipping tf wait..."
      return
    end
    puts "Waiting for DynamoDB lock key #{hint?('terraform')['tfstate_s3_bucket']}/#{hint?('terraform')['tfstate_key']} on table #{hint?('terraform')['tfstate_ddb_lock_table']}.  See this plugin's code for how to skip the lock..."
    ddb_cmd="aws dynamodb get-item --region #{hint?('terraform')['tfstate_s3_bucket_region']} --output json --consistent-read --table-name #{hint?('terraform')['tfstate_ddb_lock_table']} --key '{\"LockID\":{\"S\":\"#{hint?('terraform')['tfstate_s3_bucket']}/#{hint?('terraform')['tfstate_key']}\"}}'"
    begin
      Timeout::timeout(DDB_TIMEOUT) {
        while true
          ddb_out=`#{ddb_cmd}`
          ddb=JSON.parse(ddb_out.empty? ? '{}' : ddb_out)
          if ddb.key?('Item') #Found the lock, time to sleep
            puts "Found key, sleeping..."
            sleep(DDB_INTERVAL)
          else # Didn't find the lock key, but could also be SDK error.  No way to tell
            puts "DynamoDB lock released, continuing..."
            break
          end
        end
      }
    rescue Timeout::Error => e
      puts "Timeout, aborting..."
      abort
    end
  end
  
  collect_data(:linux) do
    tfstate_s3_url=hint?('terraform')['tfstate_s3_url'].to_s
    terraform Mash.new
    # don't assume awscli is installed
    no_output=`apt-get install awscli -yqq`
    wait_for_ddb_lock()
    #do the S3 stuff here
    if tfstate_s3_url.end_with?('.tfstate')
      #single state passed in
        url=`aws s3 presign #{tfstate_s3_url}`
        key=tfstate_s3_url.split('/').last.match(/^(.*)\.tfstate$/)[1]
        response=Faraday.get(url.strip)
        if response.status == 200
          terraform[key]=JSON.parse(response.body)
        end
    else #multi-state files
      dir_list=`aws s3 ls #{tfstate_s3_url}`
      dir_list.each_line do |l| # generate presigned URL list
        f=l.chomp.split()
        url=`aws s3 presign #{tfstate_s3_url}/#{f.last}`
        key=f.last.match(/^(.*)\.tfstate$/)[1]
        response=Faraday.get(url)
        if response.status == 200
          terraform[key]=JSON.parse(response.body)
        end
      end
    end
  end
end
