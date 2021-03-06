##  BASTIONS
##
##  FOR ADMISTRATIVE SSH ACCESS

module "bastion" {
  source                        = "../../site-modules/bastion/0.3.1"
  name                          = "bastion"
  subnet_group_octet            = "${var.subnet_group_octets["bastion"]}"
  #instance_count               = "${var.vpc-main_az_count}" ##  ONE PER AZ
  instance_count                = "1"
  instance_type                 = "t3.micro"
  base_strings                  = "${local.base_strings}"
  env_strings                   = "${local.env_strings}"
  chef_strings                  = "${local.chef_strings}"
  chef_lists                    = "${local.chef_lists}"
  chef_iam_policy_count         = "${module.chef.iam_policy_count}"
  terraform_strings             = "${local.terraform_strings}"
  vpc_strings                   = "${local.vpc-main_strings}"
  vpc_lists                     = "${local.vpc-main_lists}"
  az_count                      = "${var.vpc-main_az_count}"
  tags                          = "${local.tags}"
}
output "bastion_public_cname"   { value = "${module.bastion.public_cnames[0]}" }
output "bastion_public_cnames"  { value = "${module.bastion.public_cnames}" }
output "bastion_internal_cnames"  { value = "${module.bastion.internal_cnames}" }
