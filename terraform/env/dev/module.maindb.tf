module "maindb" {
  source                  = "../../site-modules/rds-mysql/0.1.0"
  name                    = "maindb"
  replica_count           = "0"
  master_multi_az         = "true"
  subnet_group_octet      = "${var.subnet_group_octets["maindb"]}"
  ##  FOR VERSION COMPATIBILITY, CONSULT https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
  engine_major_version    = "5.7"
  engine_minor_version    = "22"
  instance_class          = "db.t3.small"
  ##  FOR STORAGE COMPATIBILITY, CONSULT: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html
  allocated_storage       = "100"
  max_allocated_storage   = "200"
  storage_type            = "gp2"
  database_name           = "app"
  admin_username          = "admin"
  admin_password          = "password123"
  backup_retention_period = "32"
  backup_window           = "09:45-10:20" ##  AT LEAST 30 MINUTES
  maintenance_window      = "fri:14:45-fri:16:45"
  env_strings             = "${local.env_strings}"
  base_strings            = "${local.base_strings}"
  vpc_strings             = "${local.vpc-main_strings}"
  vpc_lists               = "${local.vpc-main_lists}"
  az_count                = "${var.vpc-main_az_count}"
  tags                    = "${local.tags}"
}
output "maindb_admin_password" { value = "${module.maindb.admin_password}"  }
output "maindb_admin_username" { value = "${module.maindb.admin_username}"  }
output "maindb_id"             { value = "${module.maindb.master_id}"       }
output "maindb_endpoint"       { value = "${module.maindb.master_endpoint}" }

