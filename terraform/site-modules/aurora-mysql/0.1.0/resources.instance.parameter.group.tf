resource "aws_db_parameter_group" "this" {
  name        = "${local.org-env-name}-instances"
  description = "${local.org-env-name}-instances"
  family      = "aurora-mysql5.7"
  parameter   = [ "${var.instance_parameters}" ]
  tags        = "${ merge( var.tags, map( "Name", "${local.org-env-name}-instances" ) ) }"
}
output "instance_parameter_group_id"     { value = "${aws_db_parameter_group.this.id}" }
output "instance_parameter_group_arn"    { value = "${aws_db_parameter_group.this.arn}" }

