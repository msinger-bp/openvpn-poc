##
##  GALERA CLUSTER WITH RDS BACKUP INSTANCE
##
##  COMPLEX INVOCATION EXERCISING ALL AVAILABLE PARAMETERS
## 
##  REFER TO vars.tf FOR EXPLANATIONS OF PARAMETERS AND DEFAULTS
##
module "galera2" {
  source                                          = "../../site-modules/galera/1.0.0"
  name                                            = "galera2"

  ##  GALERA CLUSTER
  subnet_group_octet                              = "${var.subnet_group_octets["galera2"]}"
  instance_count_az0                              = "2"
  instance_count_az1                              = "2"
  instance_count_az2                              = "0"
  instance_type                                   = "m5d.large"
  #ami_id                                          = "non-standard-ami.id"
  #addl_security_groups                           = [ "${module.other.sg_id}", "${module.yet-another.sg_id}" ]
  #addl_iam_policy_arns                           = [ "${module.other.iam_policy_arn}", "${module.yet-another.iam_policy_arn}" ]
  root_volume_size                                = "60"
  root_volume_type                                = "io1"
  root_volume_iops                                = "400"
  root_volume_delete_on_termination               = "false"
  mysql-binlog-vol-size                           = "150"
  mysql-binlog-vol-type                           = "io1"
  mysql-binlog-vol-iops                           = "2000"
  mysql-tmp-vol-size                              = "75"
  mysql-tmp-vol-type                              = "io1"
  mysql-tmp-vol-iops                              = "800"

  ##  RDS BACKUP INSTANCE
  rds-backup_subnet_group_octet                   = "${var.subnet_group_octets["galera2-rds-backup"]}"
  rds-backup_port                                 = "1234"
  #rds-backup_addl_security_group_ids             = "${module.other.sg_id}" ##  ADDITIONAL SECURITY GROUPS TO ATTACH TO RDS BACKUP INSTANCE
  rds-backup_multi_az                             = "true"
  rds-backup_az                                   = "${element(local.vpc-main_lists["availability_zones"],2)}"
  rds-backup_engine_major_version                 = "5.6"
  rds-backup_engine_minor_version                 = "41"
  rds-backup_instance_class                       = "db.m5.large"
  rds-backup_allocated_storage                    = "100"
  rds-backup_max_allocated_storage                = "200"
  rds-backup_storage_type                         = "io1"
  rds-backup_iops                                 = "2000"
  rds-backup_database_name                        = "backupdb"
  rds-backup_admin_username                       = "backupadmin"
  rds-backup_admin_password                       = "backuppassw0rd"
  rds-backup_iam_database_authentication_enabled  = "true"  ##  NOT SURE YET HOW TO DO THIS
  rds-backup_parameters                           = [
    { name = "slow_query_log",  value = "1" },
    { name = "long_query_time", value = "5" }
  ]
  rds-backup_backup_window                        = "09:45-10:16"
  rds-backup_skip_final_snapshot                  = "false"
  rds-backup_deletion_protection                  = "true"
  rds-backup_allow_major_version_upgrade          = "true"
  rds-backup_apply_immediately                    = "true"
  rds-backup_maintenance_window                   = "fri:14:45-fri:16:45"

  ##  GENERAL
  env_strings                                     = "${local.env_strings}"
  az_count                                        = "${var.vpc-main_az_count}"
  base_strings                                    = "${local.base_strings}"
  vpc_strings                                     = "${local.vpc-main_strings}"
  vpc_lists                                       = "${local.vpc-main_lists}"
  chef_strings                                    = "${local.chef_strings}"
  chef_lists                                      = "${local.chef_lists}"
  chef_iam_policy_count                           = "${module.chef.iam_policy_count}"
  terraform_strings                               = "${local.terraform_strings}"
  tags                                            = "${local.tags}"

}
#output "galera2_internal_cnames"                 { value = "${module.galera2.internal_cnames}" }
#output "galera2_internal_ips"                    { value = "${module.galera2.instance_private_ip_addresses}" }
#output "galera2_mount_point_mysql_data"          { value = "${module.galera2.mount_point_mysql_data}"   }
#output "galera2_mount_point_mysql_binlog"        { value = "${module.galera2.mount_point_mysql_binlog}" }
#output "galera2_mount_point_mysql_tmp"           { value = "${module.galera2.mount_point_mysql_tmp}"    }
#output "galera2_rds-backup_parameter_group_id"   { value = "${module.galera2.rds-backup_parameter_group_id}" }
#output "galera2_rds-backup_parameter_group_arn"  { value = "${module.galera2.rds-backup_parameter_group_arn}" }
#output "galera2_rds-backup_subnet_ids"           { value = "${module.galera2.rds-backup_subnet_ids}" }
#output "galera2_rds-backup_subnet_arns"          { value = "${module.galera2.rds-backup_subnet_arns}" }
#output "galera2_rds-backup_subnet_cidrs"         { value = "${module.galera2.rds-backup_subnet_cidrs}" }
#output "galera2_rds-backup_sg_id"                { value = "${module.galera2.rds-backup_sg_id}" }
#output "galera2_rds-backup_id"                   { value = "${module.galera2.rds-backup_id}" }
#output "galera2_rds-backup_port"                 { value = "${module.galera2.rds-backup_port}" }
#output "galera2_rds-backup_admin_username"       { value = "${module.galera2.rds-backup_admin_username}" }
#output "galera2_rds-backup_admin_password"       { value = "${module.galera2.rds-backup_admin_password}" }
#output "galera2_rds-backup_cname_long"           { value = "${module.galera2.rds-backup_cname_long}" }
#output "galera2_rds-backup_endpoint"             { value = "${module.galera2.rds-backup_endpoint}" }
#output "galera2_rds-backup_cname_short"          { value = "${module.galera2.rds-backup_cname_short}" }
