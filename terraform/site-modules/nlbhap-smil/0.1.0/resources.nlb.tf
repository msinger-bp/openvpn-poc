##  SUBNET CLUSTER
module "nlb_subnet_group" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//vpc-net/subnet.group.public/0.1.0/"
  name                              = "${var.name}-nlb"
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  subnet_group_octet                = "${var.subnet_group_octet_nlb}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  vpc_id                            = "${var.vpc_strings["id"]}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  az_count                          = "${var.az_count}"
  public_igw_route_table_id         = "${var.vpc_strings["public_igw_route_table_id"]}"
  tags                              = "${var.tags}"
}
output "nlb_subnet_ids"         { value = "${module.nlb_subnet_group.subnet_ids}" }
output "nlb_subnet_cidrs"       { value = "${module.nlb_subnet_group.subnet_cidrs}" }
##  NLB WITH DYNAMIC PUBLIC IP ADDRESSES
resource "aws_lb" "nlb" {
  name                              = "${local.org-env-name}"  ##  ONLY ALPHANUM & HYPHENS IN AN LB NAME
  load_balancer_type                = "network"
  internal                          = "false"
  enable_deletion_protection        = "false"
  enable_cross_zone_load_balancing  = "true"
  subnets                           = [ "${module.nlb_subnet_group.subnet_ids}" ]
  tags                              = "${local.tags_w_name}"
}
output "nlb_dns_name" { value = "${aws_lb.nlb.dns_name}" }
resource "aws_route53_record" "nlb_cname" {
  zone_id       = "${var.base_strings["public_subdomain_id"]}"
  name          = "${var.name}"
  type          = "CNAME"
  ttl           = "600"
  records       = ["${aws_lb.nlb.dns_name}"]
}
output "nlb_cname" { value = "${aws_route53_record.nlb_cname.fqdn}" }

##  NLB WITH EIPS MAPPED TO SUBNETS
#resource "aws_eip" "nlb" {
  #count                             = "${var.az_count}"
  #vpc                               = "true"
#}
#resource "aws_lb" "nlb" {
  #...
  #subnets                           = ... ##  REMOVE THIS PARAMETER
  #subnet_mapping {
    #subnet_id                       = "${module.nlb_subnet_group.subnet_ids[0]}"
    #allocation_id                   = "${aws_eip.nlb.*.id[0]}"
  #}
  #subnet_mapping {
    #subnet_id                       = "${module.nlb_subnet_group.subnet_ids[1]}"
    #allocation_id                   = "${aws_eip.nlb.*.id[1]}"
  #}
  #subnet_mapping {
    #subnet_id                       = "${module.nlb_subnet_group.subnet_ids[2]}"
    #allocation_id                   = "${aws_eip.nlb.*.id[2]}"
  #}
  #...
#}
