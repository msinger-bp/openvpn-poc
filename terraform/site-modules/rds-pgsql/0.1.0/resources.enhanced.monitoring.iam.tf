data "aws_iam_policy_document" "rds_monitoring_assume_role" {
  statement {
    actions             = [ "sts:AssumeRole" ]
    principals {
      type              = "Service"
      identifiers       = ["monitoring.rds.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "enhanced_monitoring" {
  count                 = "${var.create_monitoring_role ? 1 : 0}"
  name                  = "${local.org-env-name}-enhanced_monitoring"
  assume_role_policy    = "${data.aws_iam_policy_document.rds_monitoring_assume_role.json}"
  tags                  = "${merge( var.tags, map( "Name", "${local.org-env-name}-enhanced-monitoring" ) ) }"
}
resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  count                 = "${var.create_monitoring_role ? 1 : 0}"
  role                  = "${aws_iam_role.enhanced_monitoring.name}"
  policy_arn            = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
