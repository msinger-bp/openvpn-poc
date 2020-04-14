##  INVOCATION OF COMPLEX RDS-AURORA THREE-INSTANCE MYSQL 5.7 CLUSTER
##    * CUSTOM INSTANCE AND CLUSTER PARAMETERS
##    * CUSTOM CREDENTIALS
module "db" {
  source                  = "../../site-modules/aurora-mysql/0.1.0"
  name                    = "db"
  instance_count          = "3"
  instance_class          = "db.t3.large"
  subnet_group_octet      = "${var.subnet_group_octets["db"]}"
  instance_parameters = [
    { name = "slow_query_log",  value = "1" },
    { name = "long_query_time", value = "5" }
  ]
  cluster_parameters = [
    { name = "character_set_client", value = "utf8" },
    { name = "character_set_server", value = "utf8" }
  ]
  admin_username          = "myapp"
  admin_password          = "password"
  env_strings             = "${local.env_strings}"
  base_strings            = "${local.base_strings}"
  vpc_strings             = "${local.vpc-main_strings}"
  vpc_lists               = "${local.vpc-main_lists}"
  az_count                = "${var.vpc-main_az_count}"
  tags                    = "${local.tags}"
}
output "db_id"              { value = "${module.db.id}" }
output "db_arn"             { value = "${module.db.arn}" }
output "db_endpoint"        { value = "${module.db.endpoint}" }
output "db_admin_password"  { value = "${module.db.admin_password}" }
output "db_admin_username"  { value = "${module.db.admin_username}" }
output "db_reader_endpoint" { value = "${module.db.reader_endpoint}" }
