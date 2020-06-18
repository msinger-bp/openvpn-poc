module "alb-int" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//lb/alb.internal/0.1.4"
  name                              = "${var.name}"
  subnet_group_octet                = "${var.alb-int_subnet_group_octet}"
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  tags                              = "${var.tags}"
  vpc_id                            = "${var.vpc_strings["id"]}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  az_count                          = "${var.az_count}"
  internal_zone_id                  = "${var.vpc_strings["internal_zone_id"]}"
  nat_gw_private_route_table_ids    = "${var.vpc_lists["nat_gw_private_route_table_ids"]}"
  #logging_enabled                  = "${var.logging_enabled}"
  #log_bucket_name                  = "${var.log_bucket_name}"
  #log_location_prefix              = "${var.log_location_prefix}"
}
output "alb-int_sg_id"                  { value = "${module.alb-int.sg_id}" }
output "alb-int_arn"                    { value = "${module.alb-int.alb_arn}" }
output "alb-int_public_dns_name"        { value = "${module.alb-int.cname_long}" }
output "alb-int_public_cname"           { value = "${module.alb-int.cname_short}" }

