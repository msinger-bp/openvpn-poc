variable "name"                     { type = "string" }
variable "chef_role"                { type = "string"   default = "" }
variable "subnet_group_octet"       { type = "string" }
variable "az_count"                 { type = "string" }
variable "ami_id"                   { type = "string"   default = "" }
variable "instance_count"           { type = "string"   default = "" }
variable "instance_type"            { type = "string"   default = "" }
variable "addl_iam_policy_arns"     { type = "list"     default = [] }
variable "root_volume_size"                   { type = "string"   default = "" }
variable "root_volume_type"                   { type = "string"   default = "" }
variable "root_volume_iops"                   { type = "string"   default = "" }
variable "root_volume_delete_on_termination"  { type = "string"   default = "" }

variable "base_strings"             { type = "map" }
variable "env_strings"              { type = "map" }
variable "chef_strings"             { type = "map" }
variable "chef_lists"               { type = "map" }
variable "chef_iam_policy_count"    { type = "string" }
variable "terraform_strings"        { type = "map" }
variable "vpc_strings"              { type = "map" }
variable "vpc_lists"                { type = "map" }
variable "tags"                     { type = "map" }
