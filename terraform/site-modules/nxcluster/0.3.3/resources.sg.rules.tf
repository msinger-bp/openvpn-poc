resource "aws_security_group_rule" "http-80_from_cluster1" {
  security_group_id = "${module.cluster.sg_id}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"

  cidr_blocks = [
    "1.2.3.4/32",
    "2.3.4.5/32",
    "3.4.5.6/32",
  ]
}
