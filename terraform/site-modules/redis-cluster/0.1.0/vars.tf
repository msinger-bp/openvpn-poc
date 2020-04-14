##  ELASTICACHE-REDIS WITH "CLUSTER MODE" ENABLED

##  UNIQUE NAME FOR THIS SITE-MODULE AND ALL RESOURCES CREATED BY IT
variable "name"                             { type = "string" }
##  REPLICATION GROUP ID WILL DEFAULT TO ENV-NAME
##  1-20 CHARACTERS, ALPHANUM/HYPHENS, NO UNDERSCORES
variable "replication_group_id"             { type = "string" default = "" }

##  SUBNETS
variable "subnet_group_octet"               { type = "string" }

##  NODE CONFIG
variable "node_type"                        { type = "string" default = "" }  ##  WILL DEFAULT TO cache.t2.micro
variable "engine_version"                   { type = "string" default = "" }
variable "port"                             { type = "string" default = "6379" }
##  AT-REST ENCRYPTION
##  ONLY AWS-MANAGED KMS KEYS ARE SUPPORTED, NOT CUSTOMER-MANAGED KEYS (CMK)
##  SUPPORTED engine_version: 3.2.6, 4.0.10+ (NOT 3.2.10)
##  SUPPORTED node_type: M5, M4, T2, R5, R4
##  CAN ONLY BE ENABLED WHEN YOU CREATE A REDIS REPLICATION GROUP
##  CANNOT BE ENABLED ON EXISTING REPLICATION GROUPS
##  DEFAULT true
variable "at_rest_encryption_enabled"       { type = "string"   default = "true" }

##  CLUSTER CONFIG
variable "num_node_groups"                  { type = "string" default = "2" }
variable "replicas_per_node_group"          { type = "string" default = "1" }
variable "automatic_failover_enabled"       { type = "string" default = "true" }

##  VARIABLES FROM OTHER SITE-MODULES
variable "base_strings"                     { type = "map" }
variable "env_strings"                      { type = "map" }
variable "vpc_strings"                      { type = "map" }
variable "vpc_lists"                        { type = "map" }
variable "az_count"                         { type = "string" }
variable "tags"                             { type = "map" }
