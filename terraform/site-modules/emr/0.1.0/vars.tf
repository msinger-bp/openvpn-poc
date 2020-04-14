
##  UNIQUE MODULE RESOURCE NAME
variable "name"                                 { type = "string" }

##  NETWORK
variable "subnet_group_octet"                   { type = "string" }

##  EMR CONFIG
variable "emr_release_label"                    { type = "string" }
variable "master_instance_type"                 { type = "string"   default = "m1.medium" }
variable "master_instance_count"                { type = "string"   default = "1" }
variable "core_instance_type"                   { type = "string"   default = "m1.medium" }
variable "core_instance_count"                  { type = "string"   default = "1" }
variable "core_instance_ebs_size"               { type = "string"   default = "1" }
variable "core_instance_ebs_type"               { type = "string"   default = "gp2" }
variable "core_instance_ebs_vols_per_instance"  { type = "string"   default = "10" }
variable "ebs_root_volume_size"                 { type = "string"   default = "10" }
variable "termination_protection"               { type = "string"   default = "true" }

##  VARIABLES FROM OTHER SITE-MODULES
variable "base_strings"                     { type = "map" }
variable "env_strings"                      { type = "map" }
variable "tags"                             { type = "map" }
variable "terraform_strings"                { type = "map" }
variable "vpc_strings"                      { type = "map" }
variable "vpc_lists"                        { type = "map" }
variable "az_count"                         { type = "string" }
