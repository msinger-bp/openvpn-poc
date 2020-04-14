module "alb" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//lb/alb.internal/0.1.2"
  name                              = "${var.name}"
  subnet_group_octet                = "${var.alb_subnet_group_octet}"
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  ec2_key                           = "${var.env_strings["ec2_key"]}"
  tags                              = "${var.tags}"
  vpc_id                            = "${var.vpc_strings["id"]}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  az_count                          = "${var.az_count}"
  nat_gw_private_route_table_ids    = "${var.vpc_lists["nat_gw_private_route_table_ids"]}"
  internal_zone_id                  = "${var.vpc_strings["internal_zone_id"]}"
  #logging_enabled                  = "${var.logging_enabled}"
  #log_bucket_name                  = "${var.log_bucket_name}"
  #log_location_prefix              = "${var.log_location_prefix}"
}
output "alb_arn"                    { value = "${module.alb.alb_arn}" }
output "alb_cname_long"             { value = "${module.alb.cname_long}" }
output "alb_cname_short"            { value = "${module.alb.cname_short}" }
output "alb_sg_id"                  { value = "${module.alb.sg_id}" }

##  ALLOW THE ADMIN (BASTION, MONITORING, ETC) INSTANCES TO ACCESS THE ALB ON 80-443
resource "aws_security_group_rule" "alb_ingress_admin_80-443" {
  security_group_id         = "${module.alb.sg_id}"
  description               = "admin instances"
  type                      = "ingress"
  from_port                 = 80
  to_port                   = 443
  protocol                  = "tcp"
  source_security_group_id  = "${var.vpc_strings["admin-access_sg_id"]}"
}
