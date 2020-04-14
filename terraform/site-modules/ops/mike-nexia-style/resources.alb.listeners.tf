##  ALB
resource "aws_lb" "ops_alb" {
  name                              = "${var.name}"
  load_balancer_type                = "application"
  internal                          = false
  security_groups                   = ["${local.ops_alb_sg_id}"]
  subnets                           = ["${local.ops_alb_subnet_ids}"]
  idle_timeout                      = "${var.idle_timeout}"
  enable_cross_zone_load_balancing  = "${var.enable_cross_zone_load_balancing}"
  enable_deletion_protection        = "${var.enable_deletion_protection}"
  enable_http2                      = "${var.enable_http2}"
  ip_address_type                   = "${var.ip_address_type}"
  tags                              = "${local.tags_w_name}"
  timeouts {
    create                          = "${var.load_balancer_create_timeout}"
    delete                          = "${var.load_balancer_delete_timeout}"
    update                          = "${var.load_balancer_update_timeout}"
  }
}

##  PORT 80 LISTENER
resource "aws_lb_listener" "ops_alb_http_80" {
  load_balancer_arn     = "${aws_lb.ops_alb.arn}"
  port                  = "80"
  protocol              = "HTTP"
  default_action {
    type                = "fixed-response"
    fixed_response {
      content_type      = "text/plain"
      message_body      = "wuzzah..."
      status_code       = "400"
    }
  }
}
resource "aws_route53_record" "ops_alb_cname" {
  zone_id       = "${local.public_subdomain_id}"
  name          = "${var.name}"
  type          = "CNAME"
  ttl           = "600"
  records       = ["${aws_lb.ops_alb.dns_name}"]
}
output "ops_alb_cname_fqdn"         { value = "${aws_route53_record.ops_alb_cname.fqdn}" }
