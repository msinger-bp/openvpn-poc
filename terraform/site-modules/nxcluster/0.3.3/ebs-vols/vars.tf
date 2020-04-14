variable "name"             { type = "string" } 
variable "az"               { type = "string" } 
variable "instance_ids"     { type = "list" } 
variable "instance_count"   { type = "string" } 
variable "kms_key_arn"      { type = "string"   default = "" }
variable "env_strings"      { type = "map" } 
variable "org"              { type = "string" }
variable "env"              { type = "string" }
variable "tags"             { type = "map" }
