resource "aws_db_instance" "rds-backup" {
  identifier                            = "${local.org-env-name}-rds-backup"
  db_subnet_group_name                  = "${aws_db_subnet_group.rds-backup.name}"
  multi_az                              = "${var.rds-backup_multi_az}"
  availability_zone                     = "${ var.rds-backup_multi_az == "true" ? "" : ( var.rds-backup_az != "" ? var.rds-backup_az : element( var.vpc_lists["availability_zones"], 0 ) ) }"
  port                                  = "${var.rds-backup_port}"
  vpc_security_group_ids                = ["${aws_security_group.rds-backup.id}", "${var.vpc_strings["admin-access_sg_id"]}" ]
  engine                                = "mysql"
  engine_version                        = "${ var.rds-backup_engine_minor_version == "" ? var.rds-backup_engine_major_version : "${var.rds-backup_engine_major_version}.${var.rds-backup_engine_minor_version}" }"
  allow_major_version_upgrade           = "${var.rds-backup_allow_major_version_upgrade}"
  auto_minor_version_upgrade            = "${ var.rds-backup_engine_minor_version == "" ? "true" : "false" }"
  instance_class                        = "${ coalesce( var.rds-backup_instance_class, var.env_strings["default_rds_instance_type"] ) }"
  allocated_storage                     = "${ coalesce( var.rds-backup_allocated_storage, "10" ) }"
  max_allocated_storage                 = "${ coalesce( var.rds-backup_max_allocated_storage, var.rds-backup_allocated_storage, "10" ) }"
  storage_type                          = "${var.rds-backup_storage_type}"
  iops                                  = "${var.rds-backup_iops}"
  storage_encrypted                     = "true"
  kms_key_id                            = "${aws_kms_key.rds-backup.arn}"
  name                                  = "${var.rds-backup_database_name}"
  username                              = "${var.rds-backup_admin_username}"
  password                              = "${local.rds-backup_effective_admin_password}"
  iam_database_authentication_enabled   = "${var.rds-backup_iam_database_authentication_enabled}"
  parameter_group_name                  = "${aws_db_parameter_group.rds-backup.name}"
  backup_retention_period               = "${var.rds-backup_backup_retention_period}"
  backup_window                         = "${var.rds-backup_backup_window}"
  copy_tags_to_snapshot                 = "true"
  skip_final_snapshot                   = "${var.rds-backup_skip_final_snapshot}"
  final_snapshot_identifier             = "${local.org-env-name}-rds-backup-Final"
  deletion_protection                   = "${var.rds-backup_deletion_protection}"
  maintenance_window                    = "${var.rds-backup_maintenance_window}"
  apply_immediately                     = "${var.rds-backup_apply_immediately}"
  tags                                  = "${ merge( var.tags, map( "Name", "${local.org-env-name}-rds-backup")) }"
  lifecycle {
    ignore_changes                      = [
      "name",
      "id",
      "engine_version",
      "snapshot_identifier"
    ]
  }
  timeouts                              = "${var.rds-backup_timeouts}"

  ##  MONITORING
  #monitoring_interval                   = "${var.monitoring_interval}"
  #monitoring_role_arn                   = "${var.monitoring_role_arn}"
  #enabled_cloudwatch_logs_exports       = "${var.enabled_cloudwatch_logs_exports}"

}
output "rds-backup_id"              { value = "${aws_db_instance.rds-backup.id}" }
output "rds-backup_port"            { value = "${aws_db_instance.rds-backup.port}" }
output "rds-backup_admin_username"  { value = "${aws_db_instance.rds-backup.username}" }
output "rds-backup_admin_password"  { value = "${aws_db_instance.rds-backup.password}" }

##  INTERNAL CNAMES
resource "aws_route53_record" "rds-backup_cname_long" {
  zone_id                               = "${var.vpc_strings["internal_zone_id"]}"
  name                                  = "${local.org-env-name}-rds-backup"
  type                                  = "CNAME"
  ttl                                   = "300"
  records                               = ["${aws_db_instance.rds-backup.address}"]
}
output "rds-backup_cname_long"  { value = "${aws_route53_record.rds-backup_cname_long.fqdn}" }
output "rds-backup_endpoint"  { value = "${aws_route53_record.rds-backup_cname_long.fqdn}:${aws_db_instance.rds-backup.port}" }
resource "aws_route53_record" "rds-backup_cname_short" {
  zone_id                               = "${var.vpc_strings["internal_zone_id"]}"
  name                                  = "${var.name}-rds-backup"
  type                                  = "CNAME"
  ttl                                   = "300"
  records                               = ["${aws_db_instance.rds-backup.address}"]
}
output "rds-backup_cname_short"  { value = "${aws_route53_record.rds-backup_cname_short.fqdn}" }
