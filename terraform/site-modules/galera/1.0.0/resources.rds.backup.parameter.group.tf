resource "aws_db_parameter_group" "rds-backup" {
  name                      = "${local.org-env-name}-rds-backup"
  description               = "${local.org-env-name}-rds-backup"
  family                    = "mysql${var.rds-backup_engine_major_version}"
  parameter                 = ["${var.rds-backup_parameters}"]
  tags                      = "${ merge( local.tags_w_name, map( "Test", "${local.org-env-name}-rds-backup" ) ) }"
  lifecycle {
    create_before_destroy   = "true"
  }
}
output "rds-backup_parameter_group_id"     { value = "${aws_db_parameter_group.rds-backup.id}" }
output "rds-backup_parameter_group_arn"    { value = "${aws_db_parameter_group.rds-backup.arn}" }
