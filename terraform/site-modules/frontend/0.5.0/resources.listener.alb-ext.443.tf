##  PORT 443 LISTENER
resource "aws_lb_listener" "ext_443" {
  load_balancer_arn   = "${module.alb-ext.alb_arn}"
  port                = "443"
  protocol            = "HTTPS"
  ssl_policy          = "ELBSecurityPolicy-2016-08"
  certificate_arn     = "${module.acm.arn}"
  default_action {
    type              = "forward"
    target_group_arn  = "${aws_lb_target_group.alb-ext.arn}"
  }
}

##  ALLOW EVERYWHERE TO ACCESS THE ALB ON 443
resource "aws_security_group_rule" "alb-ext_ingress_everywhere_443" {
  security_group_id   = "${module.alb-ext.sg_id}"
  description         = "ALLOW EVERYWHERE TO ACCESS THE ALB ON 443"
  type                = "ingress"
  from_port           = 443
  to_port             = 443
  protocol            = "tcp"
  cidr_blocks         = [ "0.0.0.0/0" ]
}

