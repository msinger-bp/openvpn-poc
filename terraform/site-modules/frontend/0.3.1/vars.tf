
##  UNIQUE MODULE RESOURCE NAME
variable "name"                             { type = "string" }

##  GENERAL
variable "base_strings"                     { type = "map" }
variable "chef_strings"                     { type = "map" }
variable "chef_lists"                       { type = "map" }
variable "chef_iam_policy_count"            { type = "string" }
variable "env_strings"                      { type = "map" }
variable "tags"                             { type = "map" }
variable "terraform_strings"                { type = "map" }
variable "vpc_strings"                      { type = "map" }
variable "vpc_lists"                        { type = "map" }
variable "az_count"                         { type = "string" }

##  ALB MODULE CONFIG
# The time in seconds that the connection is allowed to be idle
#variable "idle_timeout"                     { type = "string"   default = "60"      }
#variable "enable_cross_zone_load_balancing" { type = "string"   default = "true"    }
#variable "enable_deletion_protection"       { type = "string"   default = "false"   }
#variable "enable_http2"                     { type = "string"   default = "true"    }
#variable "load_balancer_create_timeout"     { type = "string"   default = "5m"      }
#variable "load_balancer_delete_timeout"     { type = "string"   default = "5m"      }
#variable "load_balancer_update_timeout"     { type = "string"   default = "5m"      }
#variable "extra_ssl_certs"                  { type = "list"     default = []        }
#variable "extra_ssl_certs_count"            { type = "string"   default = 0         }
#variable "https_listeners"                  { type = "list"     default = []        }
#variable "https_listeners_count"            { type = "string"   default = 0         }
#variable "http_tcp_listeners"               { type = "list"     default = []        }
#variable "http_tcp_listeners_count"         { type = "string"   default = 0         }
#variable "listener_ssl_policy_default"      { type = "string"   default = "ELBSecurityPolicy-2016-08" }
#variable "logging_enabled"                  { type = "string"   default = false     }
#variable "log_bucket_name"                  { type = "string"   default = ""        }
#variable "log_location_prefix"              { type = "string"   default = ""        }
#variable "target_groups"                    { type = "list"     default = []        }
#variable "target_groups_count"              { type = "string"   default = 0         }
#variable "target_groups_defaults"           { type = "map"      default = {}        }
