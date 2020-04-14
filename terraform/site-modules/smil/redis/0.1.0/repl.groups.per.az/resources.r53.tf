
##  LONG CNAME LIKE: 
resource "aws_route53_record" "endpoint_cnames_long" {
  count   = "${var.count}"
  zone_id = "${var.vpc_strings["internal_zone_id"]}"
  name    = "${local.org-env-name}-${local.az_abbr}${format("%02d",count.index + 1)}"
  type    = "CNAME"
  records = [ "${element( aws_elasticache_replication_group.this.*.primary_endpoint_address, count.index ) }", ]
  ttl     = "600"
}
output "endpoint_cnames_long" { value = "${aws_route53_record.endpoint_cnames_long.*.fqdn}" }

##  SHORT CNAME LIKE: 
resource "aws_route53_record" "endpoint_cnames_short" {
  count   = "${var.count}"
  zone_id = "${var.vpc_strings["internal_zone_id"]}"
  name    = "${var.name}-${local.az_abbr}${format("%02d",count.index + 1)}"
  type    = "CNAME"
  records = [ "${element( aws_elasticache_replication_group.this.*.primary_endpoint_address, count.index ) }", ]
  ttl     = "600"
}
output "endpoint_cnames_short" { value = "${aws_route53_record.endpoint_cnames_short.*.fqdn}" }
