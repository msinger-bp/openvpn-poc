
##  SECURITY GROUPS
resource "aws_security_group" "master" {
  name                                  = "${local.org-env-name}-master"
  vpc_id                                = "${var.vpc_strings["id"]}"
  revoke_rules_on_delete                = true
}
output "master_sg_id" { value = "${aws_security_group.master.id}" }

resource "aws_security_group" "slave" {
  name                                  = "${local.org-env-name}-slave"
  vpc_id                                = "${var.vpc_strings["id"]}"
  revoke_rules_on_delete                = true
}
output "slave_sg_id" { value = "${aws_security_group.slave.id}" }

resource "aws_security_group" "service" {
  name                                  = "${local.org-env-name}-service"
  vpc_id                                = "${var.vpc_strings["id"]}"
  revoke_rules_on_delete                = true
}
output "service_sg_id" { value = "${aws_security_group.service.id}" }

### Really need to add the egress rules... cluster will fail to bootstrap without
resource "aws_security_group_rule" "master_egress" {
  security_group_id                     = "${aws_security_group.master.id}"
  type                                  = "egress"
  from_port                             = 0
  to_port                               = 65535
  protocol                              = "all"
  cidr_blocks                           = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "slave_egress" {
  security_group_id                     = "${aws_security_group.slave.id}"
  type                                  = "egress"
  from_port                             = 0
  to_port                               = 65535
  protocol                              = "all"
  cidr_blocks                           = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "service_egress" {
  security_group_id                     = "${aws_security_group.service.id}"
  type                                  = "egress"
  from_port                             = 0
  to_port                               = 65535
  protocol                              = "all"
  cidr_blocks                           = ["0.0.0.0/0"]
}
