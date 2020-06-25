##  PORT 80 LISTENER
resource "aws_lb_listener" "ext_80" {
  load_balancer_arn = "${module.alb-ext.alb_arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type            = "redirect"
    redirect {
      port          = "443"
      protocol      = "HTTPS"
      status_code   = "HTTP_301"
    }
  }
}

##  ALLOW EVERYWHERE TO ACCESS THE EXTERNAL ALB ON 80
resource "aws_security_group_rule" "alb-ext_ingress_everywhere_80" {
  security_group_id = "${module.alb-ext.sg_id}"
  description       = "ALLOW EVERYWHERE TO ACCESS THE ALB ON 80"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0" ]
}

