module "subnet_group" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//vpc-net/subnet.group.private/0.1.0/"
  name                              = "${local.org-env-name}"
  subnet_group_octet                = "${var.subnet_group_octet}"
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  vpc_id                            = "${var.vpc_strings["id"]}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  az_count                          = "${var.az_count}"
  nat_gw_private_route_table_ids    = "${var.vpc_lists["nat_gw_private_route_table_ids"]}"
  tags                              = "${ merge( local.tags_w_name, map( "Name", "${local.org-env-name}-redis" ) ) }"
}
resource "aws_elasticache_subnet_group" "this" {
  name                              = "${local.org-env-name}"
  subnet_ids                        = ["${module.subnet_group.subnet_ids}"]
}
