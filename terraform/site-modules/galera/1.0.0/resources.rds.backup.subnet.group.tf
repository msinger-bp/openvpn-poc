##  SUBNET CLUSTER
module "rds-backup_subnet_group" {
  source                          = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//vpc-net/subnet.group.private/0.1.0/"
  org                             = "${var.env_strings["org"]}"
  env                             = "${var.env_strings["env"]}"
  name                            = "${var.name}-rds-backup"
  vpc_cidr_16                     = "${var.vpc_strings["cidr_16"]}"
  vpc_id                          = "${var.vpc_strings["id"]}"
  az_list                         = "${var.vpc_lists["availability_zones"]}"
  az_count                        = "${var.az_count}"
  nat_gw_private_route_table_ids  = "${var.vpc_lists["nat_gw_private_route_table_ids"]}"
  subnet_group_octet              = "${var.rds-backup_subnet_group_octet}"
  tags                            = "${ merge( var.tags, map( "Name", "${local.org-env-name}-rds-backup")) }"
}
output "rds-backup_subnet_ids"    { value = "${module.rds-backup_subnet_group.subnet_ids}" }
output "rds-backup_subnet_arns"   { value = "${module.rds-backup_subnet_group.subnet_arns}" }
output "rds-backup_subnet_cidrs"  { value = "${module.rds-backup_subnet_group.subnet_cidrs}" }

resource "aws_db_subnet_group" "rds-backup" {
  name                            = "${local.org-env-name}-rds-backup"
  subnet_ids                      = ["${module.rds-backup_subnet_group.subnet_ids}"]
  tags                            = "${ merge( var.tags, map( "Name", "${local.org-env-name}-rds-backup")) }"
}
