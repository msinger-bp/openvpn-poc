##  MAIN VPC MODULE
##
##  NAMED 'MAIN' BECAUSE THERE MIGHT CONCEIVABLY BE MULTIPLE VPCS IN AN ENVIRONMENT
##
##    * VPC AND RELATED RESOURCES
##        * IGW AND NAT GATEWAYS
##        * ENDPOINTS
##        * ROUTE TABLES
##    * INTERNAL/PRIVATE ROUTE53 ZONE
##    * 'admin-access' SECURITY GROUP FOR ASSIGNING TO INSTANCES THAT REQUIRE BASTION/MONITORING ACCESS
##
module "vpc-main" {
  source                            = "../../site-modules/vpc-main/0.3.2"
  name                              = "main"
  env_strings                       = "${local.env_strings}"
  tags                              = "${local.tags}"
  cidr_16                           = "${var.vpc-main_cidr_16}"
  az_list                           = "${var.vpc-main_az_list}"
  az_count                          = "${var.vpc-main_az_count}"
  ##  VPC INTERNAL ROUTE53 ZONE NAME COULD BE MORE SPECIFIC FOR A SPECIAL VPC
  ##  EX: 'pci.env.org.internal'
  ##  BUT FOR THE MAIN VPC, IT IS SIMPLIFIED AS 'env.org.internal'
  internal_zone_name                = "${var.env}.${var.org}.internal"
}

locals {
  vpc-main_strings                  = {
    admin-access_sg_id              = "${module.vpc-main.admin-access_sg_id}"
    id                              = "${module.vpc-main.id}"
    cidr_16                         = "${module.vpc-main.cidr_16}"
    internal_zone_name              = "${module.vpc-main.internal_zone_name}"
    internal_zone_id                = "${module.vpc-main.internal_zone_id}"
    public_igw_route_table_id       = "${module.vpc-main.public_igw_route_table_id}"
  }
  vpc-main_lists                    = {
    availability_zones              = "${var.vpc-main_az_list}"
    nat_gw_private_route_table_ids  = "${module.vpc-main.nat_gw_private_route_table_ids}"
  }
}

output "vpc-main_cidr_16"                   { value = "${module.vpc-main.cidr_16}" }
output "vpc-main_endpoint_dynamodb_id"     { value = "${module.vpc-main.endpoint_dynamodb_id}" }
output "vpc-main_endpoint_dynamodb_pl_id"  { value = "${module.vpc-main.endpoint_dynamodb_pl_id}" }
output "vpc-main_endpoint_s3_id"           { value = "${module.vpc-main.endpoint_s3_id}" }
output "vpc-main_endpoint_s3_pl_id"        { value = "${module.vpc-main.endpoint_s3_pl_id}" }
output "vpc-main_internal_zone_id"         { value = "${module.vpc-main.internal_zone_id}" }
output "vpc-main_nat_gw_eips"              { value = [ "${module.vpc-main.nat_gw_eips}" ] }
