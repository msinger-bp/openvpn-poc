##  INVOCATION OF SIMPLE STANDALONE (ZERO REPLICAS) NON-AURORA RDS MYSQL CLUSTER
##  DEFAULT EVERYTHING (EXCEPT replica_count = 0)
module "db" {
  source                = "../../site-modules/rds-mysql/0.1.0"
  name                  = "db"
  replica_count         = "0"
  subnet_group_octet    = "${var.subnet_group_octets["db"]}"
  env_strings           = "${local.env_strings}"
  base_strings          = "${local.base_strings}"
  vpc_strings           = "${local.vpc-main_strings}"
  vpc_lists             = "${local.vpc-main_lists}"
  az_count              = "${var.vpc-main_az_count}"
  tags                  = "${local.tags}"
}
output "db_id"              { value = "${module.db.master_id}" }
output "db_endpoint"        { value = "${module.db.master_endpoint}" }
output "db_admin_username"  { value = "${module.db.admin_username}" }
output "db_admin_password"  { value = "${module.db.admin_password}" }
