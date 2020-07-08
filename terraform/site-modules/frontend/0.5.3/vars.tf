##  UNIQUE MODULE RESOURCE NAME
variable "name"                               { type = "string" }

##  ACM CERT FOR EXTERNAL ALB/443
variable "acm_additional_sans"                { type = "list", default = [] }

##  ALB SUBNET OCTETS
variable "alb-ext_subnet_group_octet"         { type = "string" }
variable "alb-int_subnet_group_octet"         { type = "string" }

##  INSTANCE CLUSTER
variable "instance_subnet_group_octet"        { type = "string" }
variable "placement_group_strategy"           { type = "string"   default = "" }
variable "instance_count"                     { type = "string" }
variable "ami_id"                             { type = "string"   default = "" }
variable "instance_type"                      { type = "string" }
variable "root_volume_size"                   { type = "string"   default = "" }
variable "root_volume_type"                   { type = "string"   default = "" }
variable "root_volume_iops"                   { type = "string"   default = "" }
variable "chef_role"                          { type = "string"   default = "" }
variable "addl_security_groups"               { type = "list"     default = [] }
variable "terraform_strings"                  { type = "map" }
variable "chef_strings"                       { type = "map" }
variable "chef_lists"                         { type = "map" }
variable "chef_iam_policy_count"              { type = "string" }
variable "addl_iam_policy_arns"               { type = "list"     default = [] }

##  ELASTICACHE / REDIS INSTANCE
variable "redis_subnet_group_octet"           { type = "string" }
variable "redis_engine_version"               { type = "string"   default = "5.0.6" }
variable "redis_node_type"                    { type = "string"   default = "cache.t3.medium" }
variable "redis_snapshot_window"              { type = "string"   default = "04:00-08:00" }
variable "redis_snapshot_retention_limit"     { type = "string"   default = "30" }
variable "redis_maintenance_window"           { type = "string"   default = "sun:08:15-sun:12:15" }

##  UNIVERSAL
variable "base_strings"                       { type = "map" }
variable "env_strings"                        { type = "map" }
variable "tags"                               { type = "map" }
variable "vpc_strings"                        { type = "map" }
variable "vpc_lists"                          { type = "map" }
variable "az_count"                           { type = "string" }
variable "ecr_arn"                            { type = "string" }
variable "db-main_sg"                         { type = "string" }

##  ALB MODULE CONFIG
# The time in seconds that the connection is allowed to be idle
#variable "idle_timeout"                      { type = "string"   default = "60"      }
#variable "enable_cross_zone_load_balancing"  { type = "string"   default = "true"    }
#variable "enable_deletion_protection"        { type = "string"   default = "false"   }
#variable "enable_http2"                      { type = "string"   default = "true"    }
#variable "load_balancer_create_timeout"      { type = "string"   default = "5m"      }
#variable "load_balancer_delete_timeout"      { type = "string"   default = "5m"      }
#variable "load_balancer_update_timeout"      { type = "string"   default = "5m"      }
#variable "extra_ssl_certs"                   { type = "list"     default = []        }
#variable "extra_ssl_certs_count"             { type = "string"   default = 0         }
#variable "https_listeners"                   { type = "list"     default = []        }
#variable "https_listeners_count"             { type = "string"   default = 0         }
#variable "http_tcp_listeners"                { type = "list"     default = []        }
#variable "http_tcp_listeners_count"          { type = "string"   default = 0         }
#variable "listener_ssl_policy_default"       { type = "string"   default = "ELBSecurityPolicy-2016-08" }
#variable "logging_enabled"                   { type = "string"   default = false     }
#variable "log_bucket_name"                   { type = "string"   default = ""        }
#variable "log_location_prefix"               { type = "string"   default = ""        }
#variable "target_groups"                     { type = "list"     default = []        }
#variable "target_groups_count"               { type = "string"   default = 0         }
#variable "target_groups_defaults"            { type = "map"      default = {}        }

