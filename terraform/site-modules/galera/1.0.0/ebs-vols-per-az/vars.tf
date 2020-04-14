variable "name"                 { type = "string" } 
variable "az"                   { type = "string" }                 ##  ONE AZ
variable "instance_ids"         { type = "list" }                   ##  LIST OF INSTANCES IN THE AZ
variable "instance_count"       { type = "string" }                 ##  COUNT OF INSTANCE LIST
variable "kms_key_arn"          { type = "string"   default = "" }
variable "env_strings"          { type = "map" } 
variable "tags"                 { type = "map" }

##  VOLUME 1 DETAILS
variable "volume_1_size"        { type = "string" }
variable "volume_1_type"        { type = "string" }
variable "volume_1_iops"        { type = "string" }
variable "volume_1_device_id"   { type = "string" }
variable "volume_1_encrypted"   { type = "string" }
variable "volume_1_vol_name"    { type = "string" }
variable "volume_1_vol_label"   { type = "string" }
variable "volume_1_mount_point" { type = "string" }
variable "volume_1_fs"          { type = "string" }

##  VOLUME 2 DETAILS
variable "volume_2_size"        { type = "string" }
variable "volume_2_type"        { type = "string" }
variable "volume_2_iops"        { type = "string" }
variable "volume_2_device_id"   { type = "string" }
variable "volume_2_encrypted"   { type = "string" }
variable "volume_2_vol_name"    { type = "string" }
variable "volume_2_vol_label"   { type = "string" }
variable "volume_2_mount_point" { type = "string" }
variable "volume_2_fs"          { type = "string" }
