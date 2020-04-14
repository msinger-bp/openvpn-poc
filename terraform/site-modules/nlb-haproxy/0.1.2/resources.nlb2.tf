###########################################################
##
##  NLB1 RESOURCES
##

##  SUBNET CLUSTER
module "nlb2_subnet_group" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//vpc-net/subnet.group.public/0.1.0/"
  name                              = "${var.name}-nlb2"
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  subnet_group_octet                = "${var.nlb2_subnet_group_octet}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  vpc_id                            = "${var.vpc_strings["id"]}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  az_count                          = "${var.az_count}"
  public_igw_route_table_id         = "${var.vpc_strings["public_igw_route_table_id"]}"
  tags                              = "${var.tags}"
}
output "nlb2_subnet_ids"         { value = "${module.nlb2_subnet_group.subnet_ids}" }
output "nlb2_subnet_cidrs"       { value = "${module.nlb2_subnet_group.subnet_cidrs}" }
##  NLB WITH DYNAMIC PUBLIC IP ADDRESSES
resource "aws_lb" "nlb2" {
  name                              = "${local.org-env-name}-nlb2"  ##  ONLY ALPHANUM & HYPHENS IN AN LB NAME
  load_balancer_type                = "network"
  internal                          = "false"
  enable_deletion_protection        = "false"
  enable_cross_zone_load_balancing  = "true"
  subnets                           = [ "${module.nlb2_subnet_group.subnet_ids}" ]
  tags                              = "${local.tags_w_name}"
}
output "nlb2_dns_name" { value = "${aws_lb.nlb2.dns_name}" }
resource "aws_route53_record" "nlb2_cname" {
  zone_id       = "${var.base_strings["public_subdomain_id"]}"
  name          = "${var.name}-nlb2"
  type          = "CNAME"
  ttl           = "600"
  records       = ["${aws_lb.nlb2.dns_name}"]
}
output "nlb2_cname" { value = "${aws_route53_record.nlb2_cname.fqdn}" }

##  NLB WITH EIPS MAPPED TO SUBNETS
#resource "aws_eip" "nlb2" {
  #count                             = "${var.az_count}"
  #vpc                               = "true"
#}
#resource "aws_lb" "nlb2" {
  #...
  #subnets                           = ... ##  REMOVE THIS PARAMETER
  #subnet_mapping {
    #subnet_id                       = "${module.nlb2_subnet_group.subnet_ids[0]}"
    #allocation_id                   = "${aws_eip.nlb2.*.id[0]}"
  #}
  #subnet_mapping {
    #subnet_id                       = "${module.nlb2_subnet_group.subnet_ids[1]}"
    #allocation_id                   = "${aws_eip.nlb2.*.id[1]}"
  #}
  #subnet_mapping {
    #subnet_id                       = "${module.nlb2_subnet_group.subnet_ids[2]}"
    #allocation_id                   = "${aws_eip.nlb2.*.id[2]}"
  #}
  #...
#}
