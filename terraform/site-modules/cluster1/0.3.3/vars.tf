variable "name"                             { type = "string" }
variable "subnet_group_octet"               { type = "string" }
variable "ami_id"                           { type = "string"   default = "" }  ##  DEFAULTS TO LATEST UBUNTU 18.04 AMI
variable "instance_count"                   { type = "string"   default = "1" }
variable "instance_type"                    { type = "string"   default = "" }  ##  DEFAULTS TO env_strings["default_ec2_instance_type"]
variable "data_vol_type"                    { type = "string"   default = "" }
variable "data_vol_size"                    { type = "string"   default = "" }
variable "data_vol_iops"                    { type = "string"   default = "" }
variable "log_vol_type"                     { type = "string"   default = "" }
variable "log_vol_size"                     { type = "string"   default = "" }
variable "log_vol_iops"                     { type = "string"   default = "" }
variable "addl_security_groups"             { type = "list"     default = [] }  ##  ARBITRARY LIST OF SECURITY GROUP IDS TO ATTACH TO INSTANCES
variable "instance_addl_iam_policy_arns"    { type = "list"     default = [] }  ##  ARBITRARY LIST OF IAM POLICY ARNS TO ATTACH TO INSTANCE IAM ROLE
variable "chef_role"                        { type = "string"   default = "" }  ##  DEFAULTS TO var.name
variable "az_count"                         { type = "string" }

##  VARIABLES FROM OTHER SITE-MODULES
variable "base_strings"                     { type = "map" }
variable "env_strings"                      { type = "map" }
variable "chef_strings"                     { type = "map" }
variable "chef_lists"                       { type = "map" }
variable "chef_iam_policy_count"            { type = "string" }
variable "terraform_strings"                { type = "map" }
variable "vpc_strings"                      { type = "map" }
variable "vpc_lists"                        { type = "map" }
variable "tags"                             { type = "map" }


