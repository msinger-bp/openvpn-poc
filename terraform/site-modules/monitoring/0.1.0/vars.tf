##  UNIQUE MODULE RESOURCE NAME
variable "name"                           { type = "string" }

##  NETWORK
variable "instance_subnet_group_octet"    { type = "string" }

##  INSTANCE CONFIG
variable "instance_count"                 { type = "string"   default = "1" }
variable "ami_id"                         { type = "string"   default = "" }  ##  DEFAULTS TO LATEST UBUNTU 18.04 AMI
variable "instance_type"                  { type = "string"   default = "" }  ##  DEFAULTS TO env_strings["default_ec2_instance_type"]
variable "instance_addl_security_groups"  { type = "list"     default = [] }
variable "instance_addl_iam_policy_arns"  { type = "list"     default = [] }
variable "ebs_srv_vol_size"               { type = "string"   default = "30" }
variable "ecr_arn"                        { type = "string" }

##  CHEF INTEGRATION
variable "chef_role"                      { type = "string"   default = "" }  ##  DEFAULTS TO var.name

##  VARIABLES FROM OTHER SITE-MODULES
variable "base_strings"                   { type = "map" }
variable "chef_strings"                   { type = "map" }
variable "chef_lists"                     { type = "map" }
variable "chef_iam_policy_count"          { type = "string" }
variable "env_strings"                    { type = "map" }
variable "tags"                           { type = "map" }
variable "terraform_strings"              { type = "map" }
variable "vpc_strings"                    { type = "map" }
variable "vpc_lists"                      { type = "map" }
variable "az_count"                       { type = "string" }
