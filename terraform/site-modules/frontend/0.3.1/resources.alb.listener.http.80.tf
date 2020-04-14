##  PORT 80 LISTENER
resource "aws_lb_listener" "http_80" {
  load_balancer_arn                 = "${module.alb.alb_arn}"
  port                              = "80"
  protocol                          = "HTTP"
  default_action {
    type                            = "forward"
    target_group_arn                = "${aws_lb_target_group.http_80.arn}"
  }
}

##  ALLOW EVERYWHERE TO ACCESS THE ALB ON 80
resource "aws_security_group_rule" "alb_ingress_everywhere_80" {
  security_group_id         = "${module.alb.sg_id}"
  description               = "ALLOW EVERYWHERE TO ACCESS THE ALB ON 80"
  type                      = "ingress"
  from_port                 = 80
  to_port                   = 80
  protocol                  = "tcp"
  cidr_blocks               = [ "0.0.0.0/0" ]
}

