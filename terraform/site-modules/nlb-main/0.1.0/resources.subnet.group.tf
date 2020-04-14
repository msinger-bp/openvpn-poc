module "subnet_group" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//vpc-net/subnet.group.public/0.1.0/"
  name                              = "${var.name}"
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  subnet_group_octet                = "${var.subnet_group_octet}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  vpc_id                            = "${var.vpc_strings["id"]}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  az_count                          = "${var.az_count}"
  public_igw_route_table_id         = "${var.vpc_strings["public_igw_route_table_id"]}"
  tags                              = "${var.tags}"
}
output "subnet_ids"                 { value = "${module.subnet_group.subnet_ids}" }
output "subnet_cidrs"               { value = "${module.subnet_group.subnet_cidrs}" }
