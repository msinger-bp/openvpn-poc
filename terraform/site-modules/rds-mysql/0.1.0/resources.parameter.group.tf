resource "aws_db_parameter_group" "this" {
  name                      = "${local.org-env-name}"
  description               = "${local.org-env-name}"
  family                    = "mysql${var.engine_major_version}"
  parameter                 = ["${var.parameters}"]
  tags                      = "${ merge( local.tags_w_name, map( "Test", "${local.org-env-name}-master" ) ) }"
  lifecycle {
    create_before_destroy   = "true"
  }
}
output "parameter_group_id"     { value = "${aws_db_parameter_group.this.id}" }
output "parameter_group_arn"    { value = "${aws_db_parameter_group.this.arn}" }
