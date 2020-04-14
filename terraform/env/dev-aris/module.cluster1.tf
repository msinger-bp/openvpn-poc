module "cluster1" {
  source = "../../site-modules/cluster1/0.2.0"

  subnet_group_octet = "31"
  name               = "cluster1"
  instance_count     = "${local.vpc_strings["availability_zone_count"]}" # One per AZ
  instance_type      = "c5d.large"                                       ##  TO SUPPORT NVME LOCAL/EPHEMERAL SSD VOLUMES

  env_strings       = "${local.env_strings}"
  base_strings      = "${local.base_strings}"
  base_lists        = "${local.base_lists}"
  vpc_strings       = "${local.vpc_strings}"
  vpc_lists         = "${local.vpc_lists}"
  chef_strings      = "${local.chef_strings}"
  terraform_strings = "${local.terraform_strings}"
  tags              = "${local.tags}"

  #TF12
  # env = module.env
  # base = module.base
  # chef = module.chef
  # vpc = module.vpc_main
  # terraform = module.terraform
}

#output "cluster1_internal_cnames"           { value = "${module.cluster1.internal_cnames}" }

