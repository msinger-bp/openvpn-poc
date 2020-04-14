##  INVOCATION OF FULL-FEATURED RDS (NON-AURORA) MYSQL CLUSTER
##   * TWO REPLICAS
##   * MASTER AND REPLICA MULTI-AZ
##   * CUSTOM PARAMETERS
##   * CUSTOM ENGINE VERSION
##   * CUSTOM STORAGE ALLOCATION, TYPE, IOPS
##   * CUSTOM INSTANCE TYPE
##   * CUSTOM DATABASE NAME
##   * CUSTOM CREDENTIALS
##   * CUSTOM BACKUP & MAINTENANCE
module "db" {
  source                  = "../../site-modules/rds-mysql/0.1.0"
  name                    = "db"
  subnet_group_octet      = "${var.subnet_group_octets["db"]}"
  replica_count           = "2"
  master_multi_az         = "true"
  replica_multi_az        = "true"
  engine_major_version    = "5.6"
  engine_minor_version    = "37"
  ##  NOTE: RDS ENCRYPTION NOT SUPPORTED ON db.m1.small, db.m1.medium, db.m1.large, db.m1.xlarge, db.m2.xlarge, db.m2.2xlarge, db.m2.4xlarge, db.t2.micro
  instance_class          = "db.t3.large"
  allocated_storage       = "32"
  ##  NOTE: THE TF AWS PROVIDER HAS A BUG THAT WILL CAUSE REPLICAS TO BE CREATED
  ##  WITH STORAGE AUTOSCALING DISABLED. YOU CAN ENABLE IT IN THE CONSOLE
  ##  AND TF WILL NOT TRY TO MODIFY IT DURING A SUBSEQUENT APPLY
  max_allocated_storage   = "100"
  storage_type            = "io1"
  iops                    = "2000"
  parameters              = [
    { name = "slow_query_log",  value = "1" },
    { name = "long_query_time", value = "5" }
  ]
  database_name           = "myappdb"
  admin_username          = "appdbadmin"
  admin_password          = "password"
  backup_retention_period = "32"
  backup_window           = "09:45-10:14"
  maintenance_window      = "fri:14:45-fri:16:45"
  env_strings             = "${local.env_strings}"
  base_strings            = "${local.base_strings}"
  vpc_strings             = "${local.vpc-main_strings}"
  vpc_lists               = "${local.vpc-main_lists}"
  az_count                = "${var.vpc-main_az_count}"
  tags                    = "${local.tags}"
}
output "db_master_id"         { value = "${module.db.master_id}" }
output "db_master_endpoint"   { value = "${module.db.master_endpoint}" }
output "db_replica_ids"       { value = "${module.db.replica_ids}" }
output "db_replica_endpoints" { value = "${module.db.replica_endpoints}" }
output "db_admin_username"    { value = "${module.db.admin_username}" }
output "db_admin_password"    { value = "${module.db.admin_password}" }
