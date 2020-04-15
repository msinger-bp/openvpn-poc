resource "aws_security_group_rule" "frontend-db-main-3306" {
  security_group_id         = "${var.db-main_sg}"
  description               = "homeweb to db app"
  type                      = "ingress"
  from_port                 = 3306
  to_port                   = 3306
  protocol                  = "tcp"
  source_security_group_id  = "${module.cluster.sg_id}"
}
