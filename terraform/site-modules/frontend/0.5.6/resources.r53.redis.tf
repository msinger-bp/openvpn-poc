resource "aws_route53_record" "redis-frontend" {
  zone_id = "${var.vpc_strings["internal_zone_id"]}"
  name    = "redisio-${var.name}.${var.vpc_strings["internal_zone_name"]}"
  type    = "CNAME"
  ttl     = 300
  records = [ "${module.redis.primary_endpoint_address}" ]
}

output "redis_dns_name"   { value = "${aws_route53_record.redis-frontend.name}" }
