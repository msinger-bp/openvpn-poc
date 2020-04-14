##  ALLOW BASTIONS TO ACCESS ALL MANAGED INSTANCES ON ALL PORTS
resource "aws_security_group_rule" "bastion_admin-access" {
  security_group_id         = "${var.vpc_strings["admin-access_sg_id"]}"
  description               = "allow bastions SSH access to members of the admin-access sg"
  type                      = "ingress"
  from_port                 = 1
  to_port                   = 65535
  protocol                  = "tcp"
  source_security_group_id  = "${module.cluster.sg_id}"
}
##  ALLOW BASTIONS TO PING ALL MANAGED INSTANCES
resource "aws_security_group_rule" "bastion_admin-access_ping" {
  security_group_id         = "${var.vpc_strings["admin-access_sg_id"]}"
  description               = "allow bastions ping/icmp to members of the admin-access sg"
  type                      = "ingress"
  from_port                 = -1
  to_port                   = -1
  protocol                  = "icmp"
  source_security_group_id  = "${module.cluster.sg_id}"
}
