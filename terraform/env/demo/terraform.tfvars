################################################
##
##  ENVIRONMENT CONFIG
##
##    * DIFFERENTIATES PROD/STAGEDEV1/DEV2/...
##    * DOES NOT SUPPORT INTERPOLATION, SO SOME LITERALS ARE REPEATED AND MUST AGREE
##

##  TERRAFORM S3 REMOTE STATE VARS MUST CONFORM WITH THE VALUES IN terraform.tf
tfstate_s3_bucket           = "acadience-tfstate"
tfstate_s3_bucket_region    = "us-west-2"
tfstate_key                 = "demo.tfstate"
tfstate_ddb_lock_table      = "acadience-tfstate-lock"

##  ORGANIZATION AND ENVIRONMENT NAME
##  THESE ARE USED AS TAGS AND ALSO AFFECT RESOURCE NAMING
org                         = "acadience" # I.E. "PRODUCT" NAME LIKE NEXIA, FREEDOMPOP, ALPHANUM - NO HYPHENS OR UNDERSCORES
env                         = "demo" # I.E., "dev", "prod", ETC, ALPHANUM - NO HYPHENS OR UNDERSCORES

##  OTHER GLOBAL RESOURCE TAGS
owner                       = "dlieberman" # AWS TAG TO IDENTIFY ENGINEER OR GROUP RESPONSIBLE FOR THIS ENV
billing_code                = "acadience-demo" # AWS TAG FOR BILLING ANALYSIS PURPOSES

##  AWS ACCOUNT ID
aws_account_id              = "695990525005" # BITPUSHER TF DEV ACCOUNT

##  AWS REGION
primary_aws_region          = "us-west-2"

##  DEFAULT EC2 INSTANCE CONFIGURATION
ec2_key                                   = "bitpusher" # EC2 SSH "KEY PAIR" - MUST PRE-EXIST!
default_ec2_instance_type                 = "t3.medium"
default_root_volume_size                  = "30"
default_root_volume_type                  = "gp2"
default_root_volume_iops                  = ""
default_root_volume_delete_on_termination = "true"
default_addl_volume_size                  = "50"
default_addl_volume_type                  = "gp2"
default_addl_volume_iops                  = ""
timezone                                  = "/usr/share/zoneinfo/Etc/UTC"

##  DEFAULT RDS CONFIGURATION
default_rds_instance_class   = "db.t3.micro"

##  DEFAULT ELASTICACHE REDIS CONFIGURATION
default_redis_node_type     = "cache.t2.micro"

##  VPC ADDRESSING AND AVAILABILITY ZONES
vpc-main_cidr_16            = "10.21" # FIRST TWO OCTETS OF THE MAIN VPC CIDR, MUST START WITH "10."
vpc-main_az_list            = [ "us-west-2a", "us-west-2b", "us-west-2c" ]
vpc-main_az_count           = "3" # MUST BE EQUAL TO THE NUMBER OF ITEMS IN THE ABOVE LIST

##  SUBNET ADDRESSING FOR SITE-MODULES
subnet_group_octets         = {
  bastion                   = "2"
  chef-efs-vol              = "3"
  chef-loader-instance      = "4"
  cluster1                  = "21"
  cluster2                  = "22"
  backend_alb               = "30"
  backend_instances         = "31"
  frontend_instances        = "40"
  frontend_alb-int          = "41"
  frontend_alb-ext          = "42"
  nxcluster                 = "50"
  redis                     = "60"
  redis-cluster             = "61"
  efs                       = "70"
  db1                       = "81" ##  RDS-MYSQL SIMPLE STANDALONE
  db2                       = "82" ##  RDS-MYSQL COMPLEX CLUSTER
  db3                       = "83" ##  RDS-POSTGRES SIMPLE STANDALONE
  db4                       = "84" ##  RDS-POSTGRES COMPLEX CLUSTER
  db-main                   = "85" ##  AURORA-MYSQL-5.7 SIMPLE STANDALONE
  db6                       = "86" ##  AURORA-MYSQL-5.7 COMPLEX CLUSTER
  nlbhap-nlb                = "90"
  nlbhap-instances          = "91"
  rabbitmq                  = "95"
  ops                       = "100"
  galera1                   = "111"
  galera1-rds-backup        = "112"
  galera2                   = "113"
  galera2-rds-backup        = "114"
  emr                       = "120"
  lambda                    = "130"
  maindb                    = "160"
}

##  PUBLIC ROUT53 ZONE - MUST PRE-EXIST AND BE IN THIS ACCOUNT
public_parent_domain        = "alo.acadiencelearning.org"
public_parent_domain_ID     = "Z0930604216CUCRAGA0L9"

##  CHEF INTEGRATION
chef_repo                   = "git@cgit01.bitpusher.com:acadience/infra" ##  CHANGE THIS TO YOUR GIT REPO NAME
chef_environment            = "demo" ##  CHANGE THIS TO THE CHEF ENVIRONMENT YOU WISH TO USE FOR THIS ENV

##  PRIVATE CERTIFICATE AUTHORITY
##  DISABLED B/C IT IS TOO EXPENSIVE
#root_acm_pca_arn           = ""
