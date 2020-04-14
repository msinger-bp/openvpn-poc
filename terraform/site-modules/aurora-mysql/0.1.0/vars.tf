##############################################################################3
##
##  RDS AURORA MYSQL CLUSTER
##

##  MODULE / RESOURCE NAME
variable "name"                                 { type = "string" } ##  UNIQUE RESOURCE NAME FOR THIS SITE-MODULE

##  SUBNET GROUP ADDRESSING
variable "subnet_group_octet"                   { type = "string" }

##  CLUSTER / REPLICA CONFIG
variable "instance_count"                        { type = "string"   default = "1" }

##  PORT
variable "port"                                 { type = "string"   default = "3306" }

##  ENGINE MODE
variable "engine_mode"                          { type = "string" default = "provisioned" }

##  INSTANCE CLASS
variable "instance_class"                       { type = "string"   default = "db.t3.small" }

##  SECURITY GROUP(S?)
variable "vpc_security_group_ids"               { type = "list"     default = [] }

##  AUTHENTICATION
variable "iam_database_authentication_enabled"  { type = "string"   default = "false" }
variable "admin_username"                       { type = "string"   default = "admin" }
variable "admin_password"                       { type = "string"   default = "" }

## DB INSTANCE PARAMETERS
variable "instance_parameters"                  {
  type = "list"
  default = [
    {
      name  = "slow_query_log"
      value = "1"
    },
    {
      name  = "long_query_time"
      value = "5"
    }
  ]
}

##  CLUSTER PARAMETERS
variable "cluster_parameters"                    { type = "list"     default = [] }
##  EXAMPLE:
#variable "cluster_parameters"                    { type = "list"     default = [
  #{
    #name  = "character_set_server"
    #value = "utf8"
  #}
#
  #{
    #name  = "character_set_client"
    #value = "utf8"
  #}
#] }

##  CLOUDWATCH LOGS / ENHANCED MONITORING METRICS
variable "enabled_cloudwatch_logs_exports"      { type = "list"     default = [] }
variable "monitoring_interval"                  { type = "string"   default = 0 }
variable "monitoring_role_arn"                  { type = "string"   default = "" }
variable "monitoring_role_name"                 { type = "string"   default = "rds-monitoring-role" }
variable "create_monitoring_role"               { type = "string"   default = "false" }

##  CREATE DATABASE FROM SOURCE SNAPSHOT ID LIKE: rds:production-2015-06-26-06-05
##  OTHERWISE CREATE A FRESH EMPTY DATABASE
variable "source_snapshot_identifier"           { type = "string"   default = "" }

##  BACKUPS / FINAL SNAPSHOT
variable "backup_retention_period"              { type = "string"   default = 1 }
variable "backup_window"                        { type = "string"   default = "" }
variable "skip_final_snapshot"                  { type = "string"   default = "true" }

##  DB DELETION PROTECTION
variable "deletion_protection"                  { type = "string"   default = "false" }

##  MAINTENANCE / AUTO-UPGRADES
variable "allow_major_version_upgrade"          { type = "string"   default = "false" }
variable "auto_minor_version_upgrade"           { type = "string" default = "true" }
variable "apply_immediately"                    { type = "string"   default = "false" }
variable "maintenance_window"                   { type = "string"   default = "" }

##  PERFORMANCE INSIGHTS
variable "performance_insights_enabled"         { type = "string" default = false }

##  VARIABLES FROM OTHER SITE-MODULES
variable "base_strings"                         { type = "map" }
variable "env_strings"                          { type = "map" }
variable "vpc_strings"                          { type = "map" }
variable "vpc_lists"                            { type = "map" }
variable "az_count"                             { type = "string" }
variable "tags"                                 { type = "map" }

##  TERRAFORM RESOURCE CREATION TIMEOUTS
variable "timeouts" {
  type      = "map"
  default   = {
    create  = "40m"
    update  = "80m"
    delete  = "40m"
  }
}

##  DB OPTION GROUP
##  DISABLED --  SEE resources.option.group.tf
#variable "options"                             { type = "list"     default = [] }
