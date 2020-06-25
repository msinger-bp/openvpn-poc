##  ALLOW THE EXTERNAL ALB TO ACCESS THE TARGET GROUP ON 8080-8083
resource "aws_security_group_rule" "cluster_ingress_alb-ext_8080-8083" {
  security_group_id                 = "${module.cluster.sg_id}"
  description                       = "ALLOW THE ALB TO ACCESS THE TARGET GROUP ON 8080-8083"
  type                              = "ingress"
  from_port                         = 8080
  to_port                           = 8083
  protocol                          = "tcp"
  source_security_group_id          = "${module.alb-ext.sg_id}"
}
