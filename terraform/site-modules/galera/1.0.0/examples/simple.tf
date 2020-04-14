##
##  GALERA CLUSTER WITH RDS BACKUP INSTANCE
##
##  SIMPLE INVOCATION EXERCISING MINIMAL PARAMETERS
##
##  REFER TO vars.tf FOR EXPLANATIONS OF PARAMETERS AND DEFAULTS
##
module "galera1" {
  source                            = "../../site-modules/galera/1.0.0"
  name                              = "galera1"
  subnet_group_octet                = "${var.subnet_group_octets["galera1"]}"
  instance_count_az0                = "2"
  instance_count_az1                = "2"
  instance_count_az2                = "0"
  instance_type                     = "m5d.large"
  env_strings                       = "${local.env_strings}"
  az_count                          = "${var.vpc-main_az_count}"
  base_strings                      = "${local.base_strings}"
  vpc_strings                       = "${local.vpc-main_strings}"
  vpc_lists                         = "${local.vpc-main_lists}"
  chef_strings                      = "${local.chef_strings}"
  chef_lists                        = "${local.chef_lists}"
  chef_iam_policy_count             = "${module.chef.iam_policy_count}"
  terraform_strings                 = "${local.terraform_strings}"
  tags                              = "${local.tags}"
  ##  RDS BACKUP INSTANCE
  rds-backup_subnet_group_octet     = "${var.subnet_group_octets["galera1-rds-backup"]}"
  rds-backup_allocated_storage      = "100"
  rds-backup_max_allocated_storage  = "200"
}
output "galera1_internal_cnames"          { value = "${module.galera1.internal_cnames}" }
output "galera1_internal_ips"             { value = "${module.galera1.instance_private_ip_addresses}" }
output "galera1_mount_point_mysql_data"   { value = "${module.galera1.mount_point_mysql_data}"   }
output "galera1_mount_point_mysql_binlog" { value = "${module.galera1.mount_point_mysql_binlog}" }
output "galera1_mount_point_mysql_tmp"    { value = "${module.galera1.mount_point_mysql_tmp}"    }
