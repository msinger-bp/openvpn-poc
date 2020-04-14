resource "random_id" "final_snapshot_identifier" {
  byte_length = 8
}
resource "aws_rds_cluster" "this" {
  ##  NAME
  cluster_identifier                  = "${local.org-env-name}"
  ##  ENGINE AND VERSION
  engine                              = "aurora-mysql"
  engine_version                      = "5.7"
  engine_mode                         = "${var.engine_mode}"    ##  global, parallelquery, provisioned (default), serverless
  ##  PORT
  port                                = "3306"
  ##  SUBNET GROUP
  db_subnet_group_name                = "${aws_db_subnet_group.this.name}"
  ##  SECURITY GROUP(S)
  vpc_security_group_ids              = ["${aws_security_group.this.id}"]
  ##  CREDENTIALS / AUTHENTICATION
  master_username                     = "${var.admin_username}"
  master_password                     = "${local.effective_admin_password}"
  iam_database_authentication_enabled = "${var.iam_database_authentication_enabled}"
  ##  STORAGE
  storage_encrypted                   = "true"
  kms_key_id                          = "${aws_kms_key.this.arn}"
  ##  PARAMETER GROUP
  db_cluster_parameter_group_name     = "${aws_rds_cluster_parameter_group.this.name}"
  ##  SOURCE SNAPSHOT
  snapshot_identifier                 = "${var.source_snapshot_identifier}"
  ##  BACKUPS / SNAPSHOTS
  backup_retention_period             = "${var.backup_retention_period}"
  preferred_backup_window             = "${var.backup_window}"
  skip_final_snapshot                 = "${var.skip_final_snapshot}"
  final_snapshot_identifier           = "${local.org-env-name}-${random_id.final_snapshot_identifier.hex}"
  ##  MAINTENANCE
  preferred_maintenance_window        = "${var.maintenance_window}"
  apply_immediately                   = "${var.apply_immediately}"
  ##  MONITORING
  enabled_cloudwatch_logs_exports     = "${var.enabled_cloudwatch_logs_exports}"
  ##  DELETION PROTECTION
  deletion_protection                 = "${var.deletion_protection}"
  ##  TAGS
  tags                                = "${local.tags_w_name}"
  lifecycle {
    ignore_changes                    = [
      "engine_version"
    ]
  }
}
output "id"               { value = "${aws_rds_cluster.this.id}" }
output "arn"              { value = "${aws_rds_cluster.this.arn}" }
output "endpoint"         { value = "${aws_rds_cluster.this.endpoint}" }
output "admin_username"   { value = "${aws_rds_cluster.this.master_username}" }
output "reader_endpoint"  { value = "${aws_rds_cluster.this.reader_endpoint}" }
