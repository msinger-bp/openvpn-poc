resource "aws_security_group" "this" {
  name                                  = "${local.org-env-name}"
  description                           = "${local.org-env-name}"
  vpc_id                                = "${var.vpc_strings["id"]}"
  tags                                  = "${local.tags_w_name}"
}
output "sg_id" { value = "${aws_security_group.this.id}" }


#${var.vpc_strings["admin-access_sg_id"]}

resource "aws_security_group_rule" "mysql-sequel-pro-access" {
  source_security_group_id  = "${var.vpc_strings["admin-access_sg_id"]}"
  description               = "allow mysql access from bastions for sequel-pro"
  type                      = "ingress"
  from_port                 = 3306
  to_port                   = 3306
  protocol                  = "tcp"
  security_group_id         = "${aws_security_group.this.id}"
}
