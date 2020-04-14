##  UNIQUE MODULE RESOURCE NAME
variable "name"                             { type = "string" }

variable "alb_subnet_group_octet"         { type = "string" }
variable "nagios_subnet_group_octet"      { type = "string" }
variable "sensei_subnet_group_octet"      { type = "string" }
variable "prometheus_subnet_group_octet"  { type = "string" }

variable "ami_id"                           { type = "string" }
variable "instance_count"                   { type = "string"   default = "1" }
variable "ops_nagios_instance_type"         { type = "string"   default = "t3.nano" }
variable "ops_nagios_listen_port"           { type = "string"   default = "80" }
variable "ops_sensei_instance_type"         { type = "string"   default = "t3.nano" }
variable "ops_sensei_listen_port"           { type = "string"   default = "80" }
variable "ops_prometheus_instance_type"     { type = "string"   default = "t3.nano" }
variable "ops_prometheus_listen_port"       { type = "string"   default = "80" }

##  DEFAULT ALB CONFIG
variable "enable_deletion_protection"       { type = "string"   default = false }
variable "enable_http2"                     { type = "string"   default = true }
variable "enable_cross_zone_load_balancing" { type = "string"   default = false }
variable "extra_ssl_certs"                  { type = "list"     default = [] }
variable "extra_ssl_certs_count"            { type = "string"   default = 0 }
variable "https_listeners"                  { type = "list"     default = [] }
variable "https_listeners_count"            { type = "string"   default = 0 }
variable "http_tcp_listeners"               { type = "list"     default = [] }
variable "http_tcp_listeners_count"         { type = "string"   default = 0 }
variable "idle_timeout"                     { type = "string"   default = 60 }
variable "ip_address_type"                  { type = "string"   default = "ipv4" }
variable "listener_ssl_policy_default"      { type = "string"   default = "ELBSecurityPolicy-2016-08" }
variable "load_balancer_is_internal"        { type = "string"   default = false }
variable "load_balancer_create_timeout"     { type = "string"   default = "10m" }
variable "load_balancer_delete_timeout"     { type = "string"   default = "10m" }
variable "load_balancer_update_timeout"     { type = "string"   default = "10m" }
variable "logging_enabled"                  { type = "string"   default = true }
variable "log_bucket_name"                  { type = "string"   default = "" }
variable "log_location_prefix"              { type = "string"   default = "" }
variable "target_groups"                    { type = "list"     default = [] }
variable "target_groups_count"              { type = "string"   default = 0 }
variable "target_groups_defaults"           { type = "map"      default = {} }

##  ENVIRONMENT
variable "org"                         {}
variable "env"                         {}
variable "ec2_key"                     {}
variable "addl_security_groups"                     { type = "list"     default = [] }
variable "tags"                             { type = "map" }
variable "public_subdomain"                 {}

##  VPC
variable "vpc_id"                           {}
variable "vpc_cidr_16"                      {}
variable "az_list"                          { type = "list" }
variable "az_count"                         {}
variable "nat_gw_private_route_table_ids"   { type = "list" }
variable "public_igw_route_table_id"       { type = "string" }
variable "vpc_default_route_table_id"       {}
variable "internal_zone_id"                 {}
