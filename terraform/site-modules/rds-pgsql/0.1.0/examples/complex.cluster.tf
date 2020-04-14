##  RDS (NON-AURORA) POSTGRESQL CLUSTER WITH 2 REPLICAS
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
  source                  = "../../site-modules/rds-pgsql/0.1.0"
  name                    = "db"
  subnet_group_octet      = "${var.subnet_group_octets["db"]}"
  replica_count           = "2"
  master_multi_az         = "true"
  replica_multi_az        = "true"
  engine_version          = "9.6"
  instance_class          = "db.m5.large"
  allocated_storage       = "32"
  max_allocated_storage   = "100"
  storage_type            = "io1"
  iops                    = "2000"
  parameters              = [
    { name = "log_connections",     value = "1" },
    { name = "log_disconnections",  value = "1" }
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
output  "db_master_id"            {  value  =  "${module.db.master_id}"            }
output  "db_master_endpoint"      {  value  =  "${module.db.master_endpoint}"      }
output  "db_replica_ids"          {  value  =  "${module.db.replica_ids}"          }
output  "db_replica_endpoints"    {  value  =  "${module.db.replica_endpoints}"    }
output  "db_admin_username"       {  value  =  "${module.db.admin_username}"       }
output  "db_admin_password"       {  value  =  "${module.db.admin_password}"       }
