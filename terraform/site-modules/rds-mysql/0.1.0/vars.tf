##############################################################################3
##
##  RDS (NON-AURORA) MYSQL CLUSTER
##

##  UNIQUE NAME FOR THIS SITE-MODULE AND ALL RESOURCES CREATED BY IT
variable "name"                                 { type = "string" }

##  NETWORK / SECURITY
variable "subnet_group_octet"                   { type = "string" }
variable "port"                                 { type = "string"   default = "3306" }
variable "addl_security_group_ids"              { type = "list"     default = [] }

##  CLUSTER / REPLICA CONFIG
variable "master_multi_az"                      { type = "string"   default = "false" } ## IF YOU ENABLE THIS, THEN "master_az" IS IGNORED 
variable "master_az"                            { type = "string"   default = "" }  ##  DEFAULTS TO "vpc_lists[availability_zones][0]"
variable "replica_count"                        { type = "string"   default = "1" }
variable "replica_multi_az"                     { type = "string"   default = "false" } ##  IF YOU ENABLE THIS, THEN "replica_az" IS IGNORED
variable "replica_az"                           { type = "string"   default = "" }

##  ENGINE / VERSION
variable "engine_major_version"                 { type = "string"   default = "5.7" }
variable "engine_minor_version"                 { type = "string"   default = "" }

##  INSTANCE CLASS
##  FOR RDS MYSQL INSTANCE CLASS COMPATIBILITY INFO, CONSULT: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
variable "instance_class"                       { type = "string"   default = "" }

##  STORAGE
##  FOR RDS MYSQL STORAGE COMPATILITY INFO, CONSULT: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html#Concepts.Storage
variable "allocated_storage"                    { type = "string"   default = "" }
variable "max_allocated_storage"                { type = "string"   default = "0" }
variable "storage_type"                         { type = "string"   default = "gp2" }
variable "iops"                                 { type = "string"   default = "0" }

##  DATABASE / AUTHENTICATION / CREDENTIALS
variable "database_name"                        { type = "string"   default = "db" }  ##  ALPHANUMERIC ONLY - NO HYPHENS OR UNDERSCORES
variable "admin_username"                       { type = "string"   default = "admin" }
variable "admin_password"                       { type = "string"   default = "" }
variable "iam_database_authentication_enabled"  { type = "string"   default = "false" }

##  DB OPTION GROUP DISABLED --  SEE resources.option.group.tf
#variable "options"                             { type = "list"     default = [] }

##  PARAMETER GROUP
variable "parameters"                           { type = "list"     default = [] }

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
variable "skip_final_snapshot"                  { type = "string"   default = "true" }  # THIS IS IGNORED: https://github.com/terraform-providers/terraform-provider-aws/issues/2588

##  DB DELETION PROTECTION
variable "deletion_protection"                  { type = "string"   default = "false" }

##  MAINTENANCE / AUTO-UPGRADES
variable "allow_major_version_upgrade"          { type = "string"   default = "false" }
variable "apply_immediately"                    { type = "string"   default = "false" }
variable "maintenance_window"                   { type = "string"   default = "" }  ##  "ddd:hh24:mi-ddd:hh24:mi"

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
