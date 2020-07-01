resource "aws_route53_record" "alb-ext_apex_alias" {
  zone_id = "${var.base_strings["public_subdomain_id"]}"
  name    = "${var.base_strings["public_subdomain_name"]}"
  type    = "A"
  alias {
    name                   = "${module.alb-ext.alb_dns_name}"
    zone_id                = "${module.alb-ext.alb_zone_id}"
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "alb-ext_simple" {
  zone_id = "${var.base_strings["public_subdomain_id"]}"
  name    = "${var.name}.${var.base_strings["public_subdomain_name"]}"
  type    = "A"
  alias {
    name                   = "${module.alb-ext.alb_dns_name}"
    zone_id                = "${module.alb-ext.alb_zone_id}"
    evaluate_target_health = true
  }
}
