
##  UNIQUE NAME FOR THIS SITE-MODULE AND ALL RESOURCES CREATED BY IT
variable "name"                             { type = "string" }

##  MODULE CONFIG
variable "subnet_group_octet"               { type = "string" }

##  VARIABLES FROM OTHER SITE-MODULES
variable "base_strings"                     { type = "map" }
variable "env_strings"                      { type = "map" }
variable "vpc_strings"                      { type = "map" }
variable "vpc_lists"                        { type = "map" }
variable "az_count"                         { type = "string" }
variable "tags"                             { type = "map" }

##  REDIS CONFIG
#variable "port"
#variable "node_type"
#variable "number_cache_clusters"
#variable "availability_zones"
#variable "engine_version"
#variable "automatic_failover_enabled"
