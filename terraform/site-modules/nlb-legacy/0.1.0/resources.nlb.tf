resource "aws_lb" "nlb" {
  name                              = "${local.org-env-name}"  ##  ONLY ALPHANUM & HYPHENS IN AN LB NAME
  load_balancer_type                = "network"
  internal                          = "false"
  subnet_mapping {
    subnet_id                       = "${module.subnet_group.subnet_ids[0]}"
    allocation_id                   = "${aws_eip.nlb.*.id[0]}"
  }
  subnet_mapping {
    subnet_id                       = "${module.subnet_group.subnet_ids[1]}"
    allocation_id                   = "${aws_eip.nlb.*.id[1]}"
  }
  subnet_mapping {
    subnet_id                       = "${module.subnet_group.subnet_ids[2]}"
    allocation_id                   = "${aws_eip.nlb.*.id[2]}"
  }
  enable_deletion_protection        = "false"
  enable_cross_zone_load_balancing  = "true"
  tags                              = "${local.tags_w_name}"
}
output "nlb_dns_name"               { value = "${aws_lb.nlb.dns_name}" }

##  NLB WITH DYNAMIC PUBLIC IP ADDRESSES, FOR REFERENCE
#resource "aws_lb" "nlb" {
  #name                              = "${local.org-env-name}"  ##  ONLY ALPHANUM & HYPHENS IN AN LB NAME
  #load_balancer_type                = "network"
  #internal                          = "false"
  #enable_deletion_protection        = "false"
  #enable_cross_zone_load_balancing  = "true"
  #subnets                           = [ "${module.nlb_subnet_group.subnet_ids}" ]
  #tags                              = "${local.tags_w_name}"
#}
