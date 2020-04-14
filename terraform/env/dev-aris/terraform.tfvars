##  NOTE: THESE MUST CONFORM WITH THE VALUES IN terraform.tf
s3_tfstate_bucket =            "nexia-dev-terraform"
s3_tfstate_bucket_region =     "us-west-2"
tfstate_key =                  "aris.tfstate"
tfstate_ddb_lock_table =       "dev-terraform-aris"

org = "bitpusher"
env = "dev-aris"
owner = "bp-engr"
billing_code = "bp-tf-dev"

primary_aws_region = "us-west-2"

ec2_key = "bitpusher-aris"
timezone = "/usr/share/zoneinfo/Etc/UTC"
default_instance_type = "t3.small"

vpc_main_cidr_16 = "10.70"
vpc_main_az_list = [ "us-west-2a", "us-west-2b", "us-west-2c" ]

public_parent_domain = "qa-env.nexiadev.com"
public_parent_domain_ID = "Z3U9OTYU5VAIPJ"

chef_repo = "git@cgit01.bitpusher.com:bitpusher/reference"
chef_environment = "dev"
chef_efs_mount_dir = "/var/chef"


