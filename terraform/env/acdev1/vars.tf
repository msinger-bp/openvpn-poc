######################################
######################################
##
##  ENVIRONMENT VARIABLE DEFINITIONS
##

######################################
##
##  TERRAFORM REMOTE STATE CONFIG
##
##  NOTE: THESE MUST CONFORM WITH THE VALUES IN terraform.tf

variable "tfstate_s3_bucket"          { type = "string" }
variable "tfstate_s3_bucket_region"   { type = "string" }
variable "tfstate_key"                { type = "string" }
variable "tfstate_ddb_lock_table"     { type = "string" }


######################################
##
##  ORG / SITE / ENV IDENTIFICATION

variable "org"                        { type = "string" } ##  USED IN RESOURCE NAMES, TAGS, AND ROUTE53 RECORDS
variable "env"                        { type = "string" } ##  ""
variable "owner"                      { type = "string" } ##  ONLY USED IN TAGS
variable "billing_code"               { type = "string" } ##  ""


######################################
##
##  AWS ACCOUNT / REGION

variable "aws_account_id"             { type = "string" }
variable "primary_aws_region"         { type = "string" }
#variable "backup_aws_region"         { type = "string" }   ##  NOT CURRENTLY IN USE


######################################
##
##  DEFAULT EC2 INSTANCE CONFIGURATION
##

variable "ec2_key"                                    { type = "string" }
variable "timezone"                                   { type = "string" }
variable "default_ec2_instance_type"                  { type = "string" }
variable "default_root_volume_size"                   { type = "string" }
variable "default_root_volume_type"                   { type = "string" }
variable "default_root_volume_iops"                   { type = "string" }
variable "default_root_volume_delete_on_termination"  { type = "string" }
variable "default_data_volume_size"                   { type = "string" }
variable "default_data_volume_type"                   { type = "string" }
variable "default_data_volume_iops"                   { type = "string" }
variable "default_log_volume_size"                    { type = "string" }
variable "default_log_volume_type"                    { type = "string" }
variable "default_log_volume_iops"                    { type = "string" }
variable "default_addl_volume_size"                   { type = "string" }
variable "default_addl_volume_type"                   { type = "string" }
variable "default_addl_volume_iops"                   { type = "string" }

##  DELETE ON TERMINATION IS NOT SUPPORTED FOR aws_volume_attachment RESOURCES >:{
#variable "default_addl_volume_delete_on_termination"  { type = "string" }


######################################
##
##  DEFAULT RDS CONFIGURATION
##

variable "default_rds_instance_class"  { type = "string" }


######################################
##
##  DEFAULT ELASTICACHE REDIS CONFIGURATION
##

variable "default_redis_node_type"  { type = "string" }


######################################
##
##  VPC ADDRESSING
##

##  MAIN VPC
variable "vpc-main_cidr_16"           { type = "string" }
variable "vpc-main_az_list"           { type = "list" }
variable "vpc-main_az_count"          { type = "string" }

##  PCI VPC - NOT CURRENTLY IN USE
#variable "vpc-pci_create"            { default = "false" }   # TF12
#variable "vpc-pci_cidr_16"           { type = "string" }
#variable "vpc-pci_az_list"           { type = "list" }
#variable "vpc-pci_az_count"          { type = "string" }


######################################
##
##  SUBNET OCTETS
##
##  THE BITPUSHER REFERENCE ARCHITECTURE USES A SPECIFIC CIDR ORGANIZATIONAL SCHEME
##  ...

variable "subnet_group_octets"        { type = "map" }


######################################
##
##  PUBLIC DNS
##
##  PUBLIC PARENT DOMAIN IS ASSUMED TO PRE-EXIST AND BE IN THIS ACCOUNT
##
##  IT IS VERY USEFUL TO BE ABLE TO AUTOMATICALLY CREATE PUBLIC DNS RECORDS
##  HOWEVER, IT IS TRICKY TO SET UP PERMISSIONS FOR AN IAM USER (LIKE THE OPERATOR)
##  TO MANAGE ROUTE53 RECORDS IN A ZONE THAT IS HOSTED IN A DIFFERENT ACCOUNT
##
##  SO, THIS MIGHT REQUIRE SOME RE-ENGINEERING OR CUSTOMIZATION PER CUSTOMER
##
##  TODO: MAKE THIS MORE FLEXIBLE

variable "public_parent_domain"       { type = "string" }
variable "public_parent_domain_ID"    { type = "string" }


######################################
##
##  CHEF INTEGRATION
##

variable "chef_repo"                  { type = "string" }
variable "chef_environment"           { type = "string" }


######################################
##
##  ACM PCA - PRIVATE CERTIFICATE AUTHORITY
##  
##  THE REFERENCE ENV CREATES A PCA THAT IS SUBORDINATE TO THIS "ROOT" PCA
##  THEN USES THE SUBORDINATE PCA TO CREATE PRIVATE ACM CERTS
##  FOR INTERNAL ALBS, SERVICES, ETC
##
##  THIS ROOT PCA IS SELF-SIGNED, SO THIS MEANS WE HAVE TO IMPORT IT'S
##  PUBLIC KEY INTO CLIENT SYSTEMS SO THEY WILL RESPECT THE CERT CHAIN
##

#variable "root_acm_pca_arn"           { type = "string" }


######################################
##
##  ENV CLASS DEFAULTS MAP
##
##  "env_class" IS NOT USED YET, BUT INTENDED TO DEFINE A SET OF VARIABLES (MAYBE IN A MAP)
##  THAT WOULD APPLY TO A "CLASS" OF ENVIRONMENTS. EX:
##
##  env_class_vars   {
##    dev   {
##        default_ec2_instance_type  = "t3.micro"
##        default_ec2_instance_count = "1"
##        default_rds_instance_class  = "db.t3.micro"
##        enable_ops_module          = "false"
##        at_rest_encryption         = "false"
##        ...
##    },
##    qa   {
##        default_ec2_instance_type  = "m5.large"
##        default_ec2_instance_count = "3"
##        default_rds_instance_class  = "db.r5.large"
##        enable_ops_module          = "false"
##        at_rest_encryption         = "true"
##        ...
##    },
##    stage   {
##        default_ec2_instance_type  = "m5.4xlarge"
##        default_ec2_instance_count = "3"
##        default_rds_instance_class  = "db.r5.4xlarge"
##        enable_ops_module          = "true"
##        at_rest_encryption         = "true"
##        ...
##    }
##    ...
##  }
##
##  THESE VARIABLES COULD THEN BE LOOKED UP IN A SITE MODULE LIKE:
##    instance_type = "$  {lookup(var.env_class_vars[var.env_class], "default_ec2_instance_type")}"
# variable "env_class"                { type = "string" }
