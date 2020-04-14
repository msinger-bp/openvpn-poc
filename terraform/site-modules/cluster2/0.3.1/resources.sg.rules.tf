##  ALLOW HTTP/80 FROM CLUSTER 1
resource "aws_security_group_rule" "http-80_from_cluster1" {
  security_group_id        = "${module.cluster.sg_id}"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = "${var.cluster1_sg_id}"
}
