##  EXAMPLE OF NLB-HAPROXY STACK
##  TWO STREAMS WITH CUSTOM PORTS AND HEALTH CHECK PARAMETERS, SENDING TRAFFIC TO DIFFERENT BACKENDS
##
##  NOTE: THIS CONFIGURATION WOULD REQUIRE:
##    1. ADDING THE "stream2" INPUT MAP TO vars.tf
##    2. COPYING THE "resources.stream1.tf" FILE FOR "stream2" RESOURCES
##    3. MODIFYING THE nlbhap-haproxy CHEF SITE-COOKBOOK FOR stream2 CONFIGURATION

module "nlbhap" {
  source                      = "../../site-modules/nlb-haproxy/0.1.0"
  name                        = "nlbhap"
  nlb_subnet_group_octet      = "${var.subnet_group_octets["nlbhap-nlb"]}"
  haproxy_subnet_group_octet  = "${var.subnet_group_octets["nlbhap-instances"]}"
  stream1                     = {
    nlb_port                  = "1000"
    haproxy_port              = "1001"
    backend_sg_id             = "${module.cluster1.sg_id}"
    backend_port              = "1002"
    tg_healthy_threshold      = "5"
    tg_unhealthy_threshold    = "1"
    tg_interval               = "60"
  }
  stream2                     = {
    nlb_port                  = "443"
    haproxy_port              = "80443"
    backend_sg_id             = "${module.cluster2.sg_id}"
    backend_port              = "80"
  }
  base_strings                = "${local.base_strings}"
  env_strings                 = "${local.env_strings}"
  chef_strings                = "${local.chef_strings}"
  chef_lists                  = "${local.chef_lists}"
  terraform_strings           = "${local.terraform_strings}"
  vpc_strings                 = "${local.vpc-main_strings}"
  vpc_lists                   = "${local.vpc-main_lists}"
  az_count                    = "${var.vpc-main_az_count}"
  chef_iam_policy_count       = "${module.chef.iam_policy_count}"
  tags                        = "${local.tags}"
}
##  FOR DEBUGGING CONVENIENCE
output "nlbhap_nlb_cname"                 { value = "${module.nlbhap.nlb_cname}" }
output "nlbhap_stream1_nlb_port"          { value = "${module.nlbhap.stream1_nlb_port}" }
output "nlbhap_stream2_nlb_port"          { value = "${module.nlbhap.stream2_nlb_port}" }

##  STREAM1 HAPROXY PARAMETERS - CONSUMED BY "NLBHAP" CHEF SITE-COOKBOOK TO CONFIGURE HAPROXY
output "nlbhap_stream1_haproxy_port"      { value = "${module.nlbhap.stream1_haproxy_port}" }
output "nlbhap_stream1_backend_port"      { value = "${module.nlbhap.stream1_backend_port}" }
output "nlbhap_stream1_backend_host_list" { value = [ "${module.cluster1.internal_cnames}" ] }

##  STREAM2 HAPROXY PARAMETERS - CONSUMED BY "NLBHAP" CHEF SITE-COOKBOOK TO CONFIGURE HAPROXY
output "nlbhap_stream2_haproxy_port"      { value = "${module.nlbhap.stream2_haproxy_port}" }
output "nlbhap_stream2_backend_port"      { value = "${module.nlbhap.stream2_backend_port}" }
output "nlbhap_stream2_backend_host_list" { value = [ "${module.cluster2.internal_cnames}" ] }
