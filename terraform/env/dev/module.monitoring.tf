##  MONITORING / NAGIOS
module "monitoring" {
  source                = "../../site-modules/monitoring/0.1.2"
  name                  = "monitoring"
  ##  INSTANCE CLUSTER
  subnet_group_octet    = "${var.subnet_group_octets["monitoring_instances"]}"
  instance_type         = "t3.medium"
  ecr_arn               = "arn:aws:ecr:us-west-2:695990525005:repository/monitoring"
  ##  OUTPUTS FROM REQUIRED MODULES
  env_strings           = "${local.env_strings}"
  base_strings          = "${local.base_strings}"
  vpc_strings           = "${local.vpc-main_strings}"
  vpc_lists             = "${local.vpc-main_lists}"
  az_count              = "${var.vpc-main_az_count}"
  chef_strings          = "${local.chef_strings}"
  chef_lists            = "${local.chef_lists}"
  chef_iam_policy_count = "${module.chef.iam_policy_count}"
  terraform_strings     = "${local.terraform_strings}"
  tags                  = "${local.tags}"
}
output "monitoring_internal_cnames"       { value = "${module.monitoring.internal_cnames}" }
