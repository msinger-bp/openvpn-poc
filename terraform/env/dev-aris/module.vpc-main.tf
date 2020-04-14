module "vpc_main" {
  source = "../../site-modules/vpc-main/0.2.0"

  env_strings = "${local.env_strings}"
  tags        = "${local.tags}"

  cidr_16 = "${var.vpc_main_cidr_16}"
  az_list = "${var.vpc_main_az_list}"
}

# TODO(TF12): Replace with direct module pass-thru
locals {
  vpc_strings = {
    admin_sg_id               = "${module.vpc_main.admin_sg_id}"
    availability_zone_count   = "${length(var.vpc_main_az_list)}"              # TODO: output from module
    id                        = "${module.vpc_main.id}"
    cidr_16                   = "${var.vpc_main_cidr_16}"                      # TODO: output from module
    internal_zone_id          = "${module.vpc_main.internal_zone_id}"
    public_igw_route_table_id = "${module.vpc_main.public_igw_route_table_id}"
  }

  vpc_lists = {
    availability_zones             = "${var.vpc_main_az_list}"                           # TODO: output from module
    nat_gw_private_route_table_ids = "${module.vpc_main.nat_gw_private_route_table_ids}"

    security_groups = [
      "${module.vpc_main.admin_sg_id}",
    ]
  }
}

#output "vpc-main_endpoint_dynamodb_id"              { value = "${module.vpc-main.endpoint_dynamodb_id}" }
#output "vpc-main_endpoint_dynamodb_pl_id"           { value = "${module.vpc-main.endpoint_dynamodb_pl_id}" }
#output "vpc-main_endpoint_s3_id"                    { value = "${module.vpc-main.endpoint_s3_id}" }
#output "vpc-main_endpoint_s3_pl_id"                 { value = "${module.vpc-main.endpoint_s3_pl_id}" }
#output "vpc-main_internal_zone_id"                  { value = "${module.vpc-main.internal_zone_id}" }
#output "vpc-main_nat_gw_eips"                       { value = ["${module.vpc-main.nat_gw_eips}"] }

