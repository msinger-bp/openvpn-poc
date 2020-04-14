##  EXAMPLE INVOCATION FOR NLB-HAPROXY STACK
##
##  ONE TRAFFIC STREAM, DEFAULT PORTS (80)

module "nlbhap" {
  source                      = "../../site-modules/nlb-haproxy/0.1.0"
  name                        = "nlbhap"
  nlb_subnet_group_octet      = "${var.subnet_group_octets["nlbhap-nlb"]}"
  haproxy_subnet_group_octet  = "${var.subnet_group_octets["nlbhap-instances"]}"
  stream1                     = {
    backend_sg_id             = "${module.cluster1.sg_id}"  ##  SG ID FOR THE BACKEND EC2 CLUSTER
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
output "nlbhap_stream1_nlb_port"          { value = "${module.nlbhap.stream1_nlb_port}" } ##  EXTERNAL/PUBLIC TRAFFIC PORT
output "nlbhap_stream1_url"               { value = "http://${module.nlbhap.nlb_cname}:${module.nlbhap.stream1_nlb_port}" }

##  STREAM1 HAPROXY PARAMETERS - CONSUMED BY "NLBHAP" CHEF SITE-COOKBOOK TO CONFIGURE HAPROXY
output "nlbhap_stream1_haproxy_port"      { value = "${module.nlbhap.stream1_haproxy_port}" }   ##  LISTENING PORT ON THE HAPROXY SYSTEMS
output "nlbhap_stream1_backend_port"      { value = "${module.nlbhap.stream1_backend_port}" }   ##  LISTENING PORT ON THE BACKEND SYSTEMS
output "nlbhap_stream1_backend_host_list" { value = [ "${module.cluster1.internal_cnames}" ] }  ##  LIST OF BACKEND CLUSTER INTERNAL CNAMES
