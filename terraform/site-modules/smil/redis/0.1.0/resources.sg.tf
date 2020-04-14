##  SECURITY GROUP
resource "aws_security_group" "this" {
  name        = "${local.org-env-name}"
  description = "${local.org-env-name}"
  vpc_id      = "${var.vpc_strings["id"]}"
  tags        = "${local.tags_w_name}"
}
output "sg_id" { value = "${aws_security_group.this.id}" }

##  EGRESS RULE
##  TO DO: DOES REDIS NEED AN EGRESS RULE?
resource "aws_security_group_rule" "egress" {
  security_group_id = "${aws_security_group.this.id}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

