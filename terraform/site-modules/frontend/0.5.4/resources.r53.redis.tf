resource "aws_route53_record" "redis-frontend" {
  zone_id = "${var.vpc_strings["internal_zone_id"]}"
  name    = "redisio-${var.name}.${var.vpc_strings["internal_zone_name"]}"
  type    = "A"
  alias {
    name                   = "${module.redis.primary_endpoint_address}"
    zone_id                = "${module.alb-int.alb_zone_id}"
    evaluate_target_health = true
  }
}

output "redis_dns_name"   { value = "${aws_route53_record.redis-frontend.name}" }
