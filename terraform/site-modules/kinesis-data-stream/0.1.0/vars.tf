
##  UNIQUE NAME FOR THIS SITE-MODULE AND ALL RESOURCES CREATED BY IT
variable "name"                       { type = "string" }

##  KINESIS
variable "shard_count"                { type = "string" default = "1" }
variable "retention_period"           { type = "string" default = "24" }
variable "enforce_consumer_deletion"  { type = "string" default = "false" }

##  VARIABLES FROM OTHER SITE-MODULES
variable "base_strings"         { type = "map" }
variable "env_strings"          { type = "map" }
variable "vpc_strings"          { type = "map" }
variable "vpc_lists"            { type = "map" }
variable "az_count"             { type = "string" }
variable "tags"                 { type = "map" }
