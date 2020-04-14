##  ENVIRONMENT CONFIG FILE
##  DIFFERENTIATES PROD/STAGE/DEV1/DEV2/...
##
##    * DOES NOT SUPPORT INTERPOLATION, SO SOME LITERALS ARE REPEATED AND MUST AGREE
##

######################################
##
##  TERRAFORM REMOTE STATE CONFIG
##
##  NOTE: THESE MUST CONFORM WITH THE VALUES IN terraform.tf

variable "s3_tfstate_bucket" {
  type = "string"
}

variable "s3_tfstate_bucket_region" {
  type = "string"
}

variable "tfstate_key" {
  type = "string"
}

variable "tfstate_ddb_lock_table" {
  type = "string"
}

######################################
##
##  ORG / SITE / ENV IDENTIFICATION

##  "org" AND "env" ARE USED IN RESOURCE NAMES, TAGS, AND ROUTE53 RECORDS
variable "org" {
  type = "string"
}

variable "env" {
  type = "string"
}

##  "owner" AND "billing_code" ARE ONLY USED IN TAGS
variable "owner" {
  type = "string"
}

variable "billing_code" {
  type = "string"
}

##  "env_class" IS NOT USED YET, BUT INTENDED TO DEFINE A SET OF VARIABLES (MAYBE IN A MAP)
##  THAT WOULD APPLY TO A "CLASS" OF ENVIRONMENTS. EX:
##  env_class_vars {
##   dev {
##       default_instance_type = "t3.micro"
##       default_instance_count = "1"
##       enable_ops_module = "false"
##       ...
##   },
##   qa {
##       default_instance_type = "t3.large"
##       default_instance_count = "3"
##       enable_ops_module = "false"
##       ...
##   },
##   stage {
##       default_instance_type = "c5.large"
##       default_instance_count = "6"
##       enable_ops_module = "true"
##       ...
##   }
##   ...
##  }
##  THESE VARIABLES COULD THEN BE LOOKED UP IN A SITE MODULE LIKE:
##    instance_type = "${lookup(var.env_class_vars[var.env_class], "default_instance_type")}"
# variable "env_class"                { type = "string" }

######################################
##
##  AWS ACCOUNT IN WHICH TO CREATE RESOURCES
##
##  THESE ARE REQUIRED BY THE ACCOUNT/ENVIRONMENT VERIFICATION SCRIPT
##  NOTE 5/2019: THE VERIFICATION SCRIPT IS NOT CURRENTLY IN USE

#variable "aws_account_name"         { default = "bitpusher-terraform-dev" }
#variable "aws_account_id"           { default = "509819115418" }

######################################
##
##  AWS REGIONS

variable "primary_aws_region" {
  type = "string"
}

##  IN CASE YOU NEED TO CONFIGURE RESOURCES IN A SEPARATE REGION, NOT CURRENTLY IN USE
#variable "backup_aws_region"       { default = "us-east-1" }

######################################
##
##  EC2 INSTANCE CONFIGURATION
##

variable "default_instance_type" {
  type = "string"
}

variable "ec2_key" {
  type = "string"
}

variable "timezone" {
  type = "string"
}

######################################
##
##  VPC ADDRESSING
##
##  "vpc-main" IS THE LITERAL NAME OF THE "MAIN" VPC FOR AN ENVIRONMENT
##  IT IS SPECIFICALLY NAMED IN CASE YOU EVER NEED TO ADD A SECOND VPC

##  MAIN VPC
variable "vpc_main_cidr_16" {
  type = "string"
}

variable "vpc_main_az_list" {
  type = "list"
}

##  PCI VPC
##  NOTE 5/2019: NOT CURRENTLY IN USE IN THE REFERENCE ARCHITECTURE
#variable "vpc-pci_create"          { default = "false" }
#variable "vpc-pci_cidr_16"         { default = "10.71" }
#variable "vpc-pci_az_list"         { default = [ "us-west-2a", "us-west-2b", "us-west-2c" ] }
#variable "vpc-pci_az_count"        { default = "3" }

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

variable "public_parent_domain" {
  type = "string"
}

variable "public_parent_domain_ID" {
  type = "string"
}

######################################
##
##  CHEF INTEGRATION
##

variable "chef_repo" {
  type = "string"
}

variable "chef_environment" {
  type = "string"
}

variable "chef_efs_mount_dir" {
  type = "string"
}
