##  UNIQUE MODULE RESOURCE NAME
variable "name"                           { type = "string" }

##  NLB
variable "subnet_group_octet_nlb"         { type = "string" }
variable "subnet_group_octet_haproxy"     { type = "string" }

##  TRAFFIC STREAMS
variable "stream-443"                     { type = "map" }

##  HAPROXY
variable "ami_id"                         { type = "string" default = "" }
variable "instance_type"                  { type = "string" default = "" }
variable "instance_count"                 { type = "string" default = "" }
variable "addl_security_groups"           { type = "list"   default = [] }
variable "addl_iam_policy_arns"           { type = "list"   default = [] }
variable "chef_role"                      { type = "string" default = "" }

##  BOILERPLATE STUFF
variable "base_strings"                   { type = "map" }
variable "env_strings"                    { type = "map" }
variable "chef_strings"                   { type = "map" }
variable "chef_lists"                     { type = "map" }
variable "terraform_strings"              { type = "map" }
variable "vpc_strings"                    { type = "map" }
variable "vpc_lists"                      { type = "map" }
variable "az_count"                       { type = "string" }
variable "chef_iam_policy_count"          { type = "string" }
variable "tags"                           { type = "map" }
