Create and bootstrap new Chef-integrated environment

```
cd terraform/env && cp -R reference <new env>
```

Edit vars.tf and terraform.tf

```
set bucket <state bucket>
set lock_table <dynamo db table>
aws s3 mb s3://$bucket
aws s3api put-bucket-versioning --bucket $bucket --versioning-configuration "Status=Enabled"
aws dynamodb create-table \
    --table-name "$lock_table" \
    --key-schema "AttributeName=LockID,KeyType=HASH" \
    --attribute-definitions "AttributeName=LockID,AttributeType=S" \
	--provisioned-throughput "ReadCapacityUnits=1,WriteCapacityUnits=1"
```

TODO: Discuss creating and attaching IAM policies for bucket and table here vs managing with TF

```
terraform init
terraform apply -target=module.base -target=module.vpc-main -target=module.chef-efs
```

```
terraform apply
```

TODO: Simplify
  6. Load the /var/chef EFS mount from the chef-loader instance:
     6.1. SSH to the loader instance and sudo:
           * ssh -A ubuntu@`tf state show module.chef-efs.module.chef-loader.aws_instance.instances | egrep '^public_ip' | awk '{print $3}'`
           * sudo -E -s # PRESERVES YOUR SSH-AGENT WHILE YOU SUDO SU -
     6.2. Confirm that the EFS volume is mounted correctly at /var/chef:
           * cd /var/chef
           * df . # YOU SHOULD SEE SOMETHING LIKE "fs-8439f32f.efs.us-west-2.amazonaws.com:/"
     6.3. Clone the chef repo
           * export GIT_SSH_COMMAND='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
           * git clone git@cgit01.bitpusher.com:bitpusher/reference .
     6.4. Stop the loader instance
           * shutdown -h now

