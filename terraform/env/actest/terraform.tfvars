################################################
##
##  ENVIRONMENT CONFIG
##
##    * DIFFERENTIATES PROD/STAGE/DEV1/DEV2/...
##    * DOES NOT SUPPORT INTERPOLATION, SO SOME LITERALS ARE REPEATED AND MUST AGREE
##

##  TERRAFORM S3 REMOTE STATE VARS MUST CONFORM WITH THE VALUES IN terraform.tf
tfstate_s3_bucket           = "bptfref-tfstate"
tfstate_s3_bucket_region    = "us-west-2"
tfstate_key                 = "actest.tfstate"
tfstate_ddb_lock_table      = "bptfref-tfstate-lock"

##  ORGANIZATION AND ENVIRONMENT NAME
##  THESE ARE USED AS TAGS AND ALSO AFFECT RESOURCE NAMING
org                         = "bptfref" # I.E. "PRODUCT" NAME LIKE NEXIA, FREEDOMPOP, ALPHANUM - NO HYPHENS OR UNDERSCORES
env                         = "actest" # I.E., "dev", "prod", ETC, ALPHANUM - NO HYPHENS OR UNDERSCORES

##  OTHER GLOBAL RESOURCE TAGS
owner                       = "acutchin" # AWS TAG TO IDENTIFY ENGINEER OR GROUP RESPONSIBLE FOR THIS ENV
billing_code                = "bp-tf-dev" # AWS TAG FOR BILLING ANALYSIS PURPOSES

##  AWS ACCOUNT ID
aws_account_id              = "509819115418" # BITPUSHER TF DEV ACCOUNT

##  AWS REGION
primary_aws_region          = "us-west-2"

##  DEFAULT EC2 INSTANCE CONFIGURATION
ec2_key                                   = "bp.dev" # EC2 SSH "KEY PAIR" - MUST PRE-EXIST!
default_ec2_instance_type                 = "r5.large"
default_root_volume_size                  = "10"
default_root_volume_type                  = "gp2"
default_root_volume_iops                  = ""
default_root_volume_delete_on_termination = "true"
default_addl_volume_size                  = "10"
default_addl_volume_type                  = "gp2"
default_addl_volume_iops                  = ""
timezone                                  = "/usr/share/zoneinfo/Etc/UTC"

##  DEFAULT RDS CONFIGURATION
default_rds_instance_class   = "db.t3.micro"

##  DEFAULT ELASTICACHE REDIS CONFIGURATION
default_redis_node_type     = "cache.t2.micro"

##  VPC ADDRESSING AND AVAILABILITY ZONES
vpc-main_cidr_16            = "10.19" # FIRST TWO OCTETS OF THE MAIN VPC CIDR, MUST START WITH "10."
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
  frontend_alb              = "40"
  frontend_http             = "41"
  frontend_https            = "42"
  nxcluster                 = "50"
  redis                     = "60"
  redis-cluster             = "61"
  efs                       = "70"
  db1                       = "81" ##  RDS-MYSQL SIMPLE STANDALONE
  db2                       = "82" ##  RDS-MYSQL COMPLEX CLUSTER
  db3                       = "83" ##  RDS-POSTGRES SIMPLE STANDALONE
  db4                       = "84" ##  RDS-POSTGRES COMPLEX CLUSTER
  db5                       = "85" ##  AURORA-MYSQL-5.7 SIMPLE STANDALONE
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
  smil-redis                = "131"
  smil-worker               = "132"
  smil-manager              = "133"
}

##  PUBLIC ROUT53 ZONE - MUST PRE-EXIST AND BE IN THIS ACCOUNT
public_parent_domain        = "bptfref.com"
public_parent_domain_ID     = "ZRJQOZR3AAA0T"

##  CHEF INTEGRATION
chef_repo                   = "git@cgit01.bitpusher.com:bitpusher/reference" ##  CHANGE THIS TO YOUR GIT REPO NAME
chef_environment            = "actest" ##  CHANGE THIS TO THE CHEF ENVIRONMENT YOU WISH TO USE FOR THIS ENV

##  PRIVATE CERTIFICATE AUTHORITY
##  DISABLED B/C IT IS TOO EXPENSIVE
#root_acm_pca_arn           = ""
