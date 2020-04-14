##############################################################################3
##
##  RDS (NON-AURORA) POSTGRESQL CLUSTER
##

##  UNIQUE NAME FOR THIS SITE-MODULE AND ALL RESOURCES CREATED BY IT
variable "name"                                 { type = "string" }

##  SUBNET GROUP
variable "subnet_group_octet"                   { type = "string" }

##  DB NAME - NAME FOR THE ACTUAL INITIAL DATABASE CREATED ON THE INSTANCE
##  NOT USED FOR THE RDS INSTANCE NAME, TAGS, OR ANY OTHER AWS RESOURCES
##  ALPHANUMERIC ONLY - NO HYPHENS OR UNDERSCORES
##  CANNOT BE 'db' WHEN DEPLOYING POSTGRES - RESERVED WORD
variable "database_name"                        { type = "string"   default = "postgres" }

##  CLUSTER / REPLICA CONFIG
variable "master_multi_az"                      { type = "string"   default = "false" }
variable "master_az"                            { type = "string"   default = "" }  ##  SHOULD DEFAULT TO az_list[0]
variable "replica_count"                        { type = "string"   default = "1" }
variable "replica_multi_az"                     { type = "string"   default = "false" }
variable "replica_az"                           { type = "string"   default = "" }

##  PORT
variable "port"                                 { type = "string"   default = "5432" }

##  ENGINE / VERSION
variable "engine_version"                       { type = "string"   default = "10" } ##  9.6 OR 10

##  INSTANCE CLASS
variable "instance_class"                       { type = "string"   default = "db.t3.small" }

##  STORAGE
variable "allocated_storage"                    { type = "string"   default = "" }
variable "max_allocated_storage"                { type = "string"   default = "0" }
variable "storage_type"                         { type = "string"   default = "gp2" }
variable "iops"                                 { type = "string"   default = "0" }

##  SECURITY GROUP(S?)
variable "vpc_security_group_ids"               { type = "list"     default = [] }

##  AUTHENTICATION
variable "iam_database_authentication_enabled"  { type = "string"   default = "false" }
##  ADMIN USERNAME CANNOT BE 'admin' WHEN DEPLOYING POSTGRES - RESERVED WORD
variable "admin_username"                       { type = "string"   default = "pgadmin" }
variable "admin_password"                       { type = "string"   default = "" }

##  DB OPTION GROUP
##  DISABLED --  SEE resources.option.group.tf
#variable "options"                             { type = "list"     default = [] }

##  DB INSTANCE PARAMETERS
#variable "parameters"                           { type = "list"     default = [] }
variable "parameters"                           { type = "list"     default = [
  {
    name  = "log_connections"
    value = "0"
  },
  {
    name  = "log_disconnections"
    value = "0"
  }
] }

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
variable "auto_minor_version_upgrade"           { type = "string"   default = "false" }
variable "apply_immediately"                    { type = "string"   default = "false" }
variable "maintenance_window"                   { type = "string"   default = "" }

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
