##  UNIQUE MODULE RESOURCE NAME
variable "name"               { type = "string" }

##  SUBNET OCTET
variable "subnet_group_octet" { type = "string" }

##  UNIVERSAL
variable "base_strings"       { type = "map" }
variable "env_strings"        { type = "map" }
variable "tags"               { type = "map" }
variable "vpc_strings"        { type = "map" }
variable "vpc_lists"          { type = "map" }
variable "az_count"           { type = "string" }
