resource "aws_security_group_rule" "frontend-db-main-3306" {
  security_group_id         = "${var.db-main_sg}"
  description               = "frontend to db app"
  type                      = "ingress"
  from_port                 = 3306
  to_port                   = 3306
  protocol                  = "tcp"
  source_security_group_id  = "${module.cluster.sg_id}"
}

#this rule is for dev access to DBs(via SSH to bastion)
resource "aws_security_group_rule" "bastion-db-main-3306" {
  security_group_id         = "${var.db-main_sg}"
  description               = "bastion to db app"
  type                      = "ingress"
  from_port                 = 3306
  to_port                   = 3306
  protocol                  = "tcp"
  source_security_group_id  = "${var.bastion_sg}"
}
