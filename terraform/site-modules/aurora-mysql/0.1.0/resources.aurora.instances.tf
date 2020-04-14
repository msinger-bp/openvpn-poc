resource "aws_rds_cluster_instance" "these" {
  count                           = "${var.instance_count}"
  identifier                      = "${local.org-env-name}-${count.index + 1}"
  cluster_identifier              = "${aws_rds_cluster.this.id}"
  engine                          = "${aws_rds_cluster.this.engine}"
  engine_version                  = "${aws_rds_cluster.this.engine_version}"
  instance_class                  = "${var.instance_class}"
  db_subnet_group_name            = "${aws_db_subnet_group.this.name}"
  db_parameter_group_name         = "${aws_db_parameter_group.this.name}"
  preferred_maintenance_window    = "${var.maintenance_window}"
  apply_immediately               = "${var.apply_immediately}"
  #monitoring_role_arn            = "${join("", aws_iam_role.rds_enhanced_monitoring.*.arn)}"
  #monitoring_interval            = "${var.monitoring_interval}"
  auto_minor_version_upgrade      = "${var.auto_minor_version_upgrade}"
  promotion_tier                  = "${count.index + 1}"
  #performance_insights_enabled   = "${var.performance_insights_enabled}"
  #performance_insights_kms_key_id  = "${aws_kms_key.this.arn}"
  tags                            = "${ merge( var.tags, map( "Name", "${local.org-env-name}-${count.index + 1}" ) ) }"
  lifecycle {
    ignore_changes                = [
      "engine_version" ##  OTHERWISE, TF WILL RE-CREATE FOR MINOR VERSION DIFFERENCE
    ]
  }
}
