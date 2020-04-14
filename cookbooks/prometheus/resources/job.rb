DEFAULT_PATH='/metrics'

property :name,    String,         name_property: true
property :target,  [Array, String]
property :path,    String,         default: DEFAULT_PATH
property :labels,  [Array,String], default: []
property :expert,  Hash,           default: {}
property :options, Hash,           default: {}
action :create do
  with_run_context :root do
    edit_resource(:template, node['prometheus']['config_file']) do |new_resource|
      if new_resource.expert.empty? # expert mode not enabled, lets do some sanity checks
        job={}
        job['job_name']=new_resource.name
        job.merge!(new_resource.options) unless new_resource.options.empty?
        job['metrics_path']=new_resource.path if new_resource.path != DEFAULT_PATH
        job['static_configs']=[]
        job['static_configs'] << {'targets' => [new_resource.target].flatten}
        if not [new_resource.labels].flatten.empty?
          job['labels']=[] 
          job['labels'] << [new_resource.labels].flatten
        end
      else # Expert mode enabled, let it fly
        Chef::Log.debug("Directly using hash from provided 'expert' parameter.")
        job=new_resource.expert
      end
      variables[:conf]['scrape_configs'] = [] unless variables[:conf]['scrape_configs'].kind_of?(Array)
      merged=false
      variables[:conf]['scrape_configs'].each do |c| #attempt to merge target if name and path are the same
        if c['job_name'] == job['job_name']
          if c['metrics_path'] == job['metrics_path'] #job_name and metrics_path match, merge new resource into existing
            job['static_configs'].each do |i|
              c['static_configs'] << i
            end
            merged=true
          else #metrics_path do not match, this is an error
            Chef::Log.fatal("Error: prometheus_job '#{new_resource.name}' specified multiple times with different 'metrics_path' option")
            raise Chef::Exceptions::InvalidResourceSpecification
          end
        end
      end
      if merged == false # we didn't merge the job into an existing config, add a new job
        variables[:conf]['scrape_configs'] << job
      end
    end
  end
end

