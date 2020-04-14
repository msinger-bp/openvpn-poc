##  INVOCATION OF SIMPLE ONE-INSTANCE RDS-AURORA MYSQL 5.7 CLUSTER
##    * NO MULTI-AZ
##    * DEFAULT INSTANCE CLASS (db-main.t3.small)
##    * DEFAULT INSTANCE AND CLUSTER PARAMETERS
##    * DEFAULT CREDENTIALS
module "db-main" {
  source                  = "../../site-modules/aurora-mysql/0.1.0"
  name                    = "db-main"
  subnet_group_octet      = "${var.subnet_group_octets["db-main"]}"
  env_strings             = "${local.env_strings}"
  base_strings            = "${local.base_strings}"
  vpc_strings             = "${local.vpc-main_strings}"
  vpc_lists               = "${local.vpc-main_lists}"
  az_count                = "${var.vpc-main_az_count}"
  tags                    = "${local.tags}"
}
output "db-main_id"              { value = "${module.db-main.id}" }
output "db-main_arn"             { value = "${module.db-main.arn}" }
output "db-main_admin_password"  { value = "${module.db-main.admin_password}" }
output "db-main_admin_username"  { value = "${module.db-main.admin_username}" }
output "db-main_endpoint"        { value = "${module.db-main.endpoint}" }
output "db-main_reader_endpoint" { value = "${module.db-main.reader_endpoint}" }
