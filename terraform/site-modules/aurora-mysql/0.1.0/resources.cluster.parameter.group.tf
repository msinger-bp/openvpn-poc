resource "aws_rds_cluster_parameter_group" "this" {
  name        = "${local.org-env-name}-cluster"
  description = "${local.org-env-name}-cluster"
  family      = "aurora-mysql5.7"
  parameter   = [ "${var.cluster_parameters}" ]
  tags        = "${ merge( var.tags, map( "Name", "${local.org-env-name}-cluster" ) ) }"
}
output "cluster_parameter_group_id"     { value = "${aws_rds_cluster_parameter_group.this.id}" }
output "cluster_parameter_group_arn"    { value = "${aws_rds_cluster_parameter_group.this.arn}" }
