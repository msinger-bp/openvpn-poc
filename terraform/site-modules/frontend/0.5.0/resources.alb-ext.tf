module "alb-ext" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//lb/alb.public/0.1.2"
  name                              = "${var.name}-ext"
  subnet_group_octet                = "${var.alb-ext_subnet_group_octet}"
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  tags                              = "${var.tags}"
  vpc_id                            = "${var.vpc_strings["id"]}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  az_count                          = "${var.az_count}"
  public_igw_route_table_id         = "${var.vpc_strings["public_igw_route_table_id"]}"  
  public_subdomain_id               = "${var.base_strings["public_subdomain_id"]}"
  #logging_enabled                  = "${var.logging_enabled}"
  #log_bucket_name                  = "${var.log_bucket_name}"
  #log_location_prefix              = "${var.log_location_prefix}"
}
output "alb-ext_sg_id"                  { value = "${module.alb-ext.sg_id}" }
output "alb-ext_arn"                    { value = "${module.alb-ext.alb_arn}" }
output "alb-ext_public_dns_name"        { value = "${module.alb-ext.cname_long}" }
output "alb-ext_public_cname"           { value = "${module.alb-ext.cname_short}" }

