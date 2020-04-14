##  SIMPLE/MINIMAL RDS-AURORA MYSQL 5.7 CLUSTER
##    * ONE INSTANCE
module "db" {
  source                  = "../../site-modules/aurora-mysql/0.1.0"
  name                    = "db"
  subnet_group_octet      = "${var.subnet_group_octets["db"]}"
  env_strings             = "${local.env_strings}"
  base_strings            = "${local.base_strings}"
  vpc_strings             = "${local.vpc-main_strings}"
  vpc_lists               = "${local.vpc-main_lists}"
  az_count                = "${var.vpc-main_az_count}"
  tags                    = "${local.tags}"
}
output "db_id"              { value = "${module.db.id}" }
output "db_arn"             { value = "${module.db.arn}" }
output "db_admin_password"  { value = "${module.db.admin_password}" }
output "db_admin_username"  { value = "${module.db.admin_username}" }
output "db_endpoint"        { value = "${module.db.endpoint}" }
output "db_reader_endpoint" { value = "${module.db.reader_endpoint}" }
