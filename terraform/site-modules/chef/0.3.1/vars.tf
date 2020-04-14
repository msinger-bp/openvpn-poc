variable "name"                                 { type = "string" }
variable "efs_mount_dir"                        { type = "string"   default = "/var/chef" }
output   "efs_mount_dir"                        { value = "${var.efs_mount_dir}" }   ##  PASS-THROUGH VARIABLE
variable "efs-vol_subnet_group_octet"           { type = "string" }
variable "loader-instance_subnet_group_octet"   { type = "string" }
variable "ami_id"                               { type = "string"   default = "" }
variable "instance_type"                        { type = "string"   default = "" }
variable "env_strings"                          { type = "map" }
variable "terraform_strings"                    { type = "map" }
variable "base_strings"                         { type = "map" }
variable "vpc_strings"                          { type = "map" }
variable "vpc_lists"                            { type = "map" }
variable "az_count"                             { type = "string" }
variable "tags"                                 { type = "map" }
