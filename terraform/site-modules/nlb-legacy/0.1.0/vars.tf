##  UNIQUE MODULE RESOURCE NAME
variable "name"                       { type = "string" }

##  NLB
variable "subnet_group_octet"         { type = "string" }

##  TARGET GROUP ARNS FOR LISTENER RULES
variable "haproxy-legacy_tg_8090-1_arn" { type = "string" }

##  BOILERPLATE STUFF
variable "base_strings"               { type = "map" }
variable "env_strings"                { type = "map" }
variable "chef_strings"               { type = "map" }
variable "chef_lists"                 { type = "map" }
variable "terraform_strings"          { type = "map" }
variable "vpc_strings"                { type = "map" }
variable "vpc_lists"                  { type = "map" }
variable "az_count"                   { type = "string" }
variable "chef_iam_policy_count"      { type = "string" }
variable "tags"                       { type = "map" }
