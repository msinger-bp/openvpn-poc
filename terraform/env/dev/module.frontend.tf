##  FRONTEND STACK
##
##    * PUBLIC/INTERNET-FACING ALB
##        * PORT 80 LISTENER
##        * PORT 443 LISTENER WITH AUTOMATICALLY VALIDATED PUBLIC ACM SSL CERTIFICATE
##    * TWO PRIVATE/INTERNAL, UNIQUELY-NAMED EC2 CLUSTERS
##        * PORT 80 TRAFFIC IS ROUTED TO 'HTTP' CLUSTER
##        * PORT 443 TRAFFIC IS ROUTED TO 'HTTPS' CLUSTER
##

module "frontend" {
  source                            = "../../site-modules/frontend/0.4.0"
  name                              = "frontend"
  ##  ALB CONFIG
  alb_subnet_group_octet            = "${var.subnet_group_octets["frontend_alb"]}"
  ##  HTTP CLUSTER/INSTANCE CONFIG
  http_subnet_group_octet           = "${var.subnet_group_octets["frontend_http"]}"
  http_placement_group_strategy     = "spread"
  http_instance_count               = "${var.vpc-main_az_count}"
  http_instance_type                = "t3.medium"
  http_chef_role                    = "frontend_http"
  ##  OUTPUTS FROM REQUIRED MODULES
  env_strings                       = "${local.env_strings}"
  base_strings                      = "${local.base_strings}"
  vpc_strings                       = "${local.vpc-main_strings}"
  vpc_lists                         = "${local.vpc-main_lists}"
  az_count                          = "${var.vpc-main_az_count}"
  chef_strings                      = "${local.chef_strings}"
  chef_lists                        = "${local.chef_lists}"
  chef_iam_policy_count             = "${module.chef.iam_policy_count}"
  terraform_strings                 = "${local.terraform_strings}"
  tags                              = "${local.tags}"
}
output "frontend_alb_public_cname"      { value = "${module.frontend.alb_public_cname}" }
output "frontend_http_internal_cnames"   { value = "${module.frontend.http_internal_cnames}" }
output "frontend_https_internal_cnames"   { value = "${module.frontend.https_internal_cnames}" }
