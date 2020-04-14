##  PUBLIC CNAME LIKE "nlb-main.env.org.com"
resource "aws_route53_record" "nlb_public_cname" {
  zone_id = "${var.base_strings["public_subdomain_id"]}"
  name    = "${var.name}"
  type    = "CNAME"
  records = [ "${aws_lb.nlb.dns_name}" ]
  ttl     = "600"
}
output "nlb_public_cname" { value = "${aws_route53_record.nlb_public_cname.fqdn}" }

##  PUBLIC CNAMES FOR EACH EIP/AZ LIKE "nlb-main-az0.env.org.com"
resource "aws_route53_record" "nlb_public_cname_per_az" {
  count   = "${var.az_count}"
  zone_id = "${var.base_strings["public_subdomain_id"]}"
  #name   = "${var.name}-${element(var.vpc_lists["availability_zones"],count.index)}" # "nlb-main-us-west-2a.env.org.com"
  name    = "${var.name}-az${count.index}"                                            # "nlb-main-az0.env.org.com"
  type    = "CNAME"
  records = [ "${ element( aws_eip.nlb.*.public_ip, count.index ) }" ]
  ttl     = "600"
}
output "nlb_public_cname_per_az" { value = "${aws_route53_record.nlb_public_cname_per_az.*.fqdn}" }
