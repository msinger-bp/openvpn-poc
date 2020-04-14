##  INSTANCE TARGET GROUP
resource "aws_lb_target_group" "instances_http_80" {
  name                      = "${local.org-env-name}-http-80" ##  ALPHANUMERIC AND HYPHENS ONLY (NO UNDERSCORES), <=32 CHARACTERS
  port                      = 80
  protocol                  = "HTTP"
  vpc_id                    = "${var.vpc_strings["id"]}"
  deregistration_delay      = "10"
  #stickiness {
    #type                    = "lb_cookie"
    #cookie_duration         = 1800
    #enabled                 = false
  #}
  health_check {
    healthy_threshold       = 3
    unhealthy_threshold     = 10
    timeout                 = 5
    interval                = 10
    path                    = "/index.html"
    port                    = 80
  }
}
resource "aws_lb_target_group_attachment" "instances_http_80" {
  count             = "${var.instance_count}"
  target_group_arn  = "${aws_lb_target_group.instances_http_80.arn}"
  port              = 80
  target_id         = "${module.instance_cluster.instance_ids[count.index]}"
  ##  THIS IS REQUIRED DUE TO THE TF11 'ELEMENT' ISSUE
  lifecycle {
    ignore_changes  = [ "target_id" ]
  }
}
##  ALLOW THE ALB TO ACCESS THE TARGET GROUP ON 80
resource "aws_security_group_rule" "instance_cluster_ingress_alb_80" {
  security_group_id         = "${module.instance_cluster.sg_id}"
  description               = "ALLOW THE ALB TO ACCESS THE TARGET GROUP ON 80"
  type                      = "ingress"
  from_port                 = 80
  to_port                   = 80
  protocol                  = "tcp"
  source_security_group_id  = "${module.alb.sg_id}"
}
