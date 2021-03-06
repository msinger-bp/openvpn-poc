##  SUBNET CLUSTER
module "subnet_group" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//vpc-net/subnet.group.private/0.1.0/"
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  name                              = "${var.name}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  vpc_id                            = "${var.vpc_strings["id"]}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  az_count                          = "${var.az_count}"
  nat_gw_private_route_table_ids    = "${var.vpc_lists["nat_gw_private_route_table_ids"]}"
  subnet_group_octet                = "${var.subnet_group_octet}"
  tags                              = "${var.tags}"
}
output "subnet_ids"     { value = "${module.subnet_group.subnet_ids}" }
output "subnet_arns"    { value = "${module.subnet_group.subnet_arns}" }
output "subnet_cidrs"   { value = "${module.subnet_group.subnet_cidrs}" }

resource "aws_db_subnet_group" "this" {
  name                              = "${local.org-env-name}"
  subnet_ids                        = ["${module.subnet_group.subnet_ids}"]
  tags                              = "${local.tags_w_name}"
}
