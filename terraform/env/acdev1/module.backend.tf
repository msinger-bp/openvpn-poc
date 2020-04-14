##  BACKEND STACK:
##    INTERNAL ALB
##    HTTP/80 LISTENER
##    HTTP/443 LISTENER WITH PRIVATE ACM CERT - ON HOLD WHILE WE FIGURE OUT THE PCA ISSUE
##    EC2 CLUSTER FOR HANDLING REQUESTS WITH
module "backend" {
  source                            = "../../site-modules/backend/0.3.1"
  name                              = "backend"
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
  #  ALB CONFIG
  alb_subnet_group_octet            = "${var.subnet_group_octets["backend_alb"]}"
  #  INSTANCE CONFIG
  instance_subnet_group_octet       = "${var.subnet_group_octets["backend_instances"]}"
  instance_count                    = "${var.vpc-main_az_count}"
  instance_type                     = "t3.nano"
  #instance_addl_iam_policy_arns    = []
}
output "backend_alb_cname_short"    { value = "${module.backend.alb_cname_short}" }
