module "subnet_group" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//vpc-net/subnet.group.private/0.1.0/"
  name                              = "${var.name}"
  ##  NETWORK
  subnet_group_octet                = "${var.subnet_group_octet}"
  ##  ENVIRONMENT
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  tags                              = "${var.tags}"
  ##  VPC
  vpc_id                            = "${var.vpc_strings["id"]}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  az_count                          = "${var.az_count}"
  nat_gw_private_route_table_ids    = "${var.vpc_lists["nat_gw_private_route_table_ids"]}"
}
output "subnet_ids"     { value = "${module.subnet_group.subnet_ids}" }
output "subnet_arns"    { value = "${module.subnet_group.subnet_arns}" }
output "subnet_cidrs"   { value = "${module.subnet_group.subnet_cidrs}" }
