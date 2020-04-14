resource "aws_elasticache_parameter_group" "this" {
  name      = "${local.org-env-name}"
  family    = "${var.parameter_group_family}"
  parameter = [ "${var.parameters}" ]
}
