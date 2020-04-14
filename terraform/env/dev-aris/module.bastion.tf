module "bastion" {
  source = "../../site-modules/bastion/0.2.0"

  subnet_group_octet = "2"

  # instance_count = "1"      # Defaults to one per VPC AZ
  instance_type = "t3.nano" # Typically does not need to be as large as the default size

  base_strings      = "${local.base_strings}"
  base_lists        = "${local.base_lists}"
  env_strings       = "${local.env_strings}"
  chef_strings      = "${local.chef_strings}"
  terraform_strings = "${local.terraform_strings}"
  vpc_strings       = "${local.vpc_strings}"
  vpc_lists         = "${local.vpc_lists}"
  tags              = "${local.tags}"

  #TF12
  # env = module.env
  # base = module.base
  # chef = module.chef
  # vpc = module.vpc_main
  # terraform = module.terraform
}

# output "bastion_public_cnames"     { value = "${module.bastion.public_cnames}" }
# output "bastion_public_cname"      { value = "${module.bastion.public_cname}" }

