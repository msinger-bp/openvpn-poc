##  UNIQUE NAME FOR THIS SITE-MODULE AND ALL RESOURCES CREATED BY IT
variable "name"                       { type = "string" }

##  CLUSTER COUNT PER AZ
variable "repl_group_count_az0"       { type = "string" }
variable "repl_group_count_az1"       { type = "string" }
variable "repl_group_count_az2"       { type = "string" }

##  NETWORK
variable "subnet_group_octet"         { type = "string" }
variable "port"                       { type = "string"   default = "6379" }

##  NODE
variable "node_type"                  { type = "string"   default = "" }
variable "engine_version"             { type = "string"   default = "5.0.5" }

##  ENCRYPTION
variable "at_rest_encryption_enabled" { type = "string"   default = "true" }
variable "transit_encryption_enabled" { type = "string"   default = "true" }

##  SNAPSHOT / MAINTENANCE SCHEDULE
variable "snapshot_window"            { type = "string"   default = "" }  ##  "hh24:mi-hh24:mi" ("02:30-03:30")
variable "snapshot_retention_limit"   { type = "string"   default = "0" } ##  BACKUPS DISABLED BY DEFAULT
variable "maintenance_window"         { type = "string"   default = "" }  ##  "dddhh24:mi-dddhh24:mi" ("thu23:30-fri01:30"), MUST NOT OVERLAP WITH SNAPSHOT WINDOW

##  PARAMETER GROUP
variable "parameter_group_family"     { type = "string"   default = "redis5.0" }
variable "parameters"                 {
  type = "list"
  default = []
  #default = [
    #{
      #name  = "<param_one>"
      #value = "<value>"
    #},
    #{
      #name  = "<param_two>"
      #value = "<value>"
    #}
  #]
}

##  SNS INTEGRATION
variable "notification_topic_arn"     { type = "string"   default = "" }

##  BASE / ENV / VPC
variable "base_strings"               { type = "map" }
variable "env_strings"                { type = "map" }
variable "vpc_strings"                { type = "map" }
variable "vpc_lists"                  { type = "map" }
variable "az_count"                   { type = "string" }
variable "tags"                       { type = "map" }
