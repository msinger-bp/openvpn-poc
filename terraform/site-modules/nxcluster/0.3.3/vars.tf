variable "name"                             { type = "string" }
variable "subnet_group_octet"               { type = "string" }
variable "placement_group_strategy"         { type = "string"   default = "" }
variable "ami_id"                           { type = "string"   default = "" }  ##  DEFAULTS TO LATEST UBUNTU 18.04 AMI
variable "az_0_instance_count"              { type = "string"   default = 1 }
variable "az_1_instance_count"              { type = "string"   default = 1 }
variable "az_2_instance_count"              { type = "string"   default = 1 }
variable "instance_type"                    { type = "string"   default = "" }  ##  DEFAULTS TO env_strings["default_ec2_instance_type"]
variable "addl_security_groups"             { type = "list"     default = [] }  ##  ARBITRARY LIST OF SECURITY GROUP IDS TO ATTACH TO INSTANCES
variable "addl_iam_policy_arns"             { type = "list"     default = [] }  ##  ARBITRARY LIST OF IAM POLICY ARNS TO ATTACH TO INSTANCE IAM ROLE
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

