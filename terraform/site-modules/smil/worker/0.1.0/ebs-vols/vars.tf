variable "name"                     { type = "string" } 
variable "az"                       { type = "string" } 
variable "instance_ids"             { type = "list" } 
variable "instance_count"           { type = "string" } 
variable "kms_key_arn"              { type = "string"   default = "" }
variable "env_strings"              { type = "map" } 
variable "tags"                     { type = "map" }
variable "data_volume_type"         { type = "string" }
variable "data_volume_iops"         { type = "string" }
variable "data_volume_size"         { type = "string" }
variable "data_volume_mount_point"  { type = "string" }
