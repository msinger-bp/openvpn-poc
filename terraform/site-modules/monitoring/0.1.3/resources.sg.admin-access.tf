##  ALLOW PROMETHEUS SYSTEMS TO ACCESS MEMBERS OF THE ADMIN-ACCESS SECURITY GROUP ON 9100
resource "aws_security_group_rule" "prometheus_admin-access_9100" {
  security_group_id = "${var.vpc_strings["admin-access_sg_id"]}"
  description       = "allow prometheus access to members of the admin-access sg on 9100"
  type              = "ingress"
  from_port         = 9100
  to_port           = 9100
  protocol          = "tcp"
  source_security_group_id  = "${module.cluster.sg_id}"
}
##  ALLOW PROMETHEUS SYSTEMS TO ACCESS MEMBERS OF THE ADMIN-ACCESS SECURITY GROUP ON 9323
resource "aws_security_group_rule" "prometheus_admin-access_9323" {
  security_group_id = "${var.vpc_strings["admin-access_sg_id"]}"
  description       = "allow prometheus access to members of the admin-access sg on 9323"
  type              = "ingress"
  from_port         = 9323
  to_port           = 9323
  protocol          = "tcp"
  source_security_group_id  = "${module.cluster.sg_id}"
}
##  ALLOW PROMETHEUS SYSTEMS TO PING ALL MANAGED INSTANCES
resource "aws_security_group_rule" "bastion_admin-access_ping" {
  security_group_id         = "${var.vpc_strings["admin-access_sg_id"]}"
  description               = "allow prometheus to ping/icmp to members of the admin-access sg"
  type                      = "ingress"
  from_port                 = -1
  to_port                   = -1
  protocol                  = "icmp"
  source_security_group_id  = "${module.cluster.sg_id}"
}
##  ALLOW PROMETHEUS SYSTEMS NRPE/5666 TO ALL MANAGED INSTANCES
resource "aws_security_group_rule" "bastion_admin-access_nrpe_5666" {
  security_group_id         = "${var.vpc_strings["admin-access_sg_id"]}"
  description               = "allow prometheus nrpe/5666 to to members of the admin-access sg"
  type                      = "ingress"
  from_port                 = 5666
  to_port                   = 5666
  protocol                  = "tcp"
  source_security_group_id  = "${module.cluster.sg_id}"
}
##  ALLOW PROMETHEUS SYSTEMS MYSQL/3306 TO ALL MANAGED INSTANCES
resource "aws_security_group_rule" "prometheus_admin-access_mysql_3306" {
  security_group_id         = "${var.vpc_strings["admin-access_sg_id"]}"
  description               = "allow prometheus mysql/3306 to to members of the admin-access sg"
  type                      = "ingress"
  from_port                 = 3306
  to_port                   = 3306
  protocol                  = "tcp"
  source_security_group_id  = "${module.cluster.sg_id}"
}
