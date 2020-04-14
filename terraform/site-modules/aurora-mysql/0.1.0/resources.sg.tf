resource "aws_security_group" "this" {
  name                                  = "${local.org-env-name}"
  description                           = "${local.org-env-name}"
  vpc_id                                = "${var.vpc_strings["id"]}"
  tags                                  = "${local.tags_w_name}"
}
output "sg_id" { value = "${aws_security_group.this.id}" }
