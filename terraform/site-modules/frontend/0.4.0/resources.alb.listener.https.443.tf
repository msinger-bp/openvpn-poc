##  ACM PUBLIC CERTIFICATE FOR HTTPS/443
module "acm" {
  source    = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//lb/acm/0.1.0"
  name      = "${var.name}"
  org       = "${var.env_strings["org"]}"
  env       = "${var.env_strings["env"]}"
  tags      = "${var.tags}"
  ##  PUBLIC ROUTE53 DNS SUBDOMAIN/ZONE
  ##  CERT NAME WILL BE "${var.name}.${var.public_subdomain_name}"
  zone_id   = "${var.base_strings["public_subdomain_id"]}"
  zone_name = "${var.base_strings["public_subdomain_name"]}"
}

##  PORT 443 LISTENER
resource "aws_lb_listener" "http_443" {
  load_balancer_arn                 = "${module.alb.alb_arn}"
  port                              = "443"
  protocol                          = "HTTPS"
  ssl_policy                        = "ELBSecurityPolicy-2016-08"
  certificate_arn                   = "${module.acm.arn}"
  default_action {
    type                            = "forward"
    target_group_arn                = "${aws_lb_target_group.https_80.arn}"
  }
}

##  ALLOW EVERYWHERE TO ACCESS THE ALB ON 443
resource "aws_security_group_rule" "alb_ingress_everywhere_443" {
  security_group_id         = "${module.alb.sg_id}"
  description               = "ALLOW EVERYWHERE TO ACCESS THE ALB ON 443"
  type                      = "ingress"
  from_port                 = 443
  to_port                   = 443
  protocol                  = "tcp"
  cidr_blocks               = [ "0.0.0.0/0" ]
}

