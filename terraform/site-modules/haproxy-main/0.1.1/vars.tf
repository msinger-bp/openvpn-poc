##  UNIQUE MODULE RESOURCE NAME
variable "name"                               { type = "string" }

##  NLB
variable "subnet_group_octet"                 { type = "string" }

##  TARGET GROUP(S)
variable "tg-8090-1"                          { type    = "map"   default = {} }
variable "tg-8090-2"                          { type    = "map"   default = {} }

##  HAPROXY
variable "ami_id"                             { type = "string"   default = "" }
variable "instance_type"                      { type = "string"   default = "" }
variable "instance_count_az0"                 { type = "string"   default = 1 }
variable "instance_count_az1"                 { type = "string"   default = 1 }
variable "instance_count_az2"                 { type = "string"   default = 1 }
variable "root_volume_size"                   { type = "string"   default = "" }
variable "root_volume_type"                   { type = "string"   default = "" }
variable "root_volume_iops"                   { type = "string"   default = "" }
variable "root_volume_delete_on_termination"  { type = "string"   default = "" }
variable "data_volume_type"                   { type = "string"   default = "gp2" }
variable "data_volume_iops"                   { type = "string"   default = "" }
variable "data_volume_size"                   { type = "string"   default = "100" }
variable "addl_security_groups"               { type = "list"     default = [] }
variable "addl_iam_policy_arns"               { type = "list"     default = [] }
variable "chef_role"                          { type = "string"   default = "" }

##  BOILERPLATE STUFF
variable "base_strings"                       { type = "map" }
variable "env_strings"                        { type = "map" }
variable "chef_strings"                       { type = "map" }
variable "chef_lists"                         { type = "map" }
variable "terraform_strings"                  { type = "map" }
variable "vpc_strings"                        { type = "map" }
variable "vpc_lists"                          { type = "map" }
variable "az_count"                           { type = "string" }
variable "chef_iam_policy_count"              { type = "string" }
variable "tags"                               { type = "map" }
