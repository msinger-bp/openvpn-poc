module "cluster2" {
  source = "../../site-modules/cluster2/0.2.0"

  subnet_group_octet = "32"
  name               = "cluster2"
  instance_count     = "${local.vpc_strings["availability_zone_count"]}" # One per AZ
  instance_type      = "t3.small"
  cluster1_sg_id     = "${module.cluster1.sg_id}"

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

#output "cluster2_internal_cnames"           { value = "${module.cluster2.internal_cnames}" }

