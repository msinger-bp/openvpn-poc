##  NXCLUSTER EC2 CLUSTER
##  DEMONSTRATES THE "cluster.private.per-az" LIBRARY MODULE
##  WHICH ALLOWS SPECIFYING A SEPARATE INSTANCE COUNT PER AZ
##  AND IDENTIFIES THE AZ IN THE HOSTNAME/CNAME/TAG
module "nxcluster" {
  source = "../../site-modules/nxcluster/0.2.0"

  subnet_group_octet  = "40"
  az_0_instance_count = "1"
  az_1_instance_count = "2"
  az_2_instance_count = "3"
  instance_type       = "c5d.large" ##  TO SUPPORT NVME LOCAL/EPHEMERAL SSD VOLUMES

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
