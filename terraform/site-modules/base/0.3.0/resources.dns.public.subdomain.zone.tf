##  PUBLIC SUBDOMAIN ZONE
##  SUBDOMAIN OF THE 'PARENT' ZONE SPECIFIED IN env.vars.tf
##  VARIOUS MODULES CREATE PUBLIC CNAMES IN THIS ZONE
##  FOR CONVENIENT EXTERNAL ACCESS
##  EX: 'bastion.envX.domain.com', 'ecs1.envX.domain.com'
resource "aws_route53_zone" "public_subdomain" {
  name      = "${var.env_strings["public_subdomain"]}"
  tags      = "${ merge( var.tags, map( "Name", "${local.org-env}-public-subdomain" ) ) }"
}

resource "aws_route53_record" "public_subdomain_ns" {
  zone_id   = "${var.env_strings["public_parent_domain_ID"]}"
  name      = "${var.env_strings["env"]}"
  type      = "NS"
  ttl       = "30"

  records   = [
    "${aws_route53_zone.public_subdomain.name_servers.0}",
    "${aws_route53_zone.public_subdomain.name_servers.1}",
    "${aws_route53_zone.public_subdomain.name_servers.2}",
    "${aws_route53_zone.public_subdomain.name_servers.3}",
  ]
}

output "public_subdomain_id"    { value = "${aws_route53_zone.public_subdomain.id}" }
output "public_subdomain_name"  { value = "${aws_route53_zone.public_subdomain.name}" }
