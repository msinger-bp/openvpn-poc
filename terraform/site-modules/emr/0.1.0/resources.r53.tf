resource "aws_route53_record" "master_node" {
  zone_id = "${var.vpc_strings["internal_zone_id"]}"
  name    = "${var.name}-master"
  type    = "CNAME"
  records = [ "${aws_emr_cluster.this.master_public_dns}", ]
  ttl     = "600"
}
output "master_node_cname" { value = "${aws_route53_record.master_node.fqdn}" }
