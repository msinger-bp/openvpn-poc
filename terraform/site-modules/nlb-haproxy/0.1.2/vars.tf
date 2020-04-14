##  UNIQUE MODULE RESOURCE NAME
variable "name"                           { type = "string"                 }

##  NLB
variable "nlb1_subnet_group_octet"        { type = "string"                 }
variable "nlb2_subnet_group_octet"        { type = "string"                 }

##  TRAFFIC STREAMS
variable "nlb1stream1"                    { type = "map" }
variable "nlb1stream1_nlb_ports"          { type = "list" }
variable "nlb1stream2"                    { type = "map" }
variable "nlb1stream2_nlb_ports"          { type = "list" }
variable "nlb2stream1"                    { type = "map" }
variable "nlb2stream1_nlb_ports"          { type = "list" }
variable "nlb2stream2"                    { type = "map" }
variable "nlb2stream2_nlb_ports"          { type = "list" }

##  HAPROXY
variable "haproxy_subnet_group_octet"     { type = "string"                 }
variable "ami_id"                         { type = "string" default = ""    }
variable "instance_type"                  { type = "string" default = ""    }
variable "instance_count"                 { type = "string" default = ""    }
variable "addl_security_groups"           { type = "list"   default = []    }
variable "addl_iam_policy_arns"           { type = "list"   default = []    }
variable "chef_role"                      { type = "string" default = ""    }

##  BOILERPLATE STUFF
variable "base_strings"                   { type = "map" }
variable "env_strings"                    { type = "map" }
variable "chef_strings"                   { type = "map" }
variable "chef_lists"                     { type = "map" }
variable "terraform_strings"              { type = "map" }
variable "vpc_strings"                    { type = "map" }
variable "vpc_lists"                      { type = "map" }
variable "az_count"                       { type = "string" }
variable "chef_iam_policy_count"          { type = "string" }
variable "tags"                           { type = "map" }
