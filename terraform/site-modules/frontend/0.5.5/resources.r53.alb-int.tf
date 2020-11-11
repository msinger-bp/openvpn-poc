resource "aws_route53_record" "alb-int" {
  zone_id = "${var.vpc_strings["internal_zone_id"]}"
  name    = "${var.name}.${var.vpc_strings["internal_zone_name"]}"
  type    = "A"
  alias {
    name                   = "${module.alb-int.alb_dns_name}"
    zone_id                = "${module.alb-int.alb_zone_id}"
    evaluate_target_health = true
  }
}
