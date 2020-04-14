##  CLUSTER OF EC2 INSTANCES
##
##  ONE INSTANCE COUNT VARIABLE SPECIFIED - TF DISTRIBUTES ACROSS AZS AUTOMATICALLY
##

module "cluster" {
  source                    = "../../site-modules/cluster2/0.3.1"
  name                      = "cluster"
  subnet_group_octet        = "${var.subnet_group_octets["cluster"]}"
  instance_count            = "${var.vpc-main_az_count}" ##  ONE PER AZ
  instance_type             = "c5d.large" ##  TO SUPPORT NVME LOCAL/EPHEMERAL SSD VOLUMES
  placement_group_strategy  = "spread"    ##  OPTIONAL, ONLY "SPREAD" SUPPORTED, DEFAULT IS NO PLACEMENT GROUP
  env_strings               = "${local.env_strings}"
  az_count                  = "${var.vpc-main_az_count}"
  base_strings              = "${local.base_strings}"
  vpc_strings               = "${local.vpc-main_strings}"
  vpc_lists                 = "${local.vpc-main_lists}"
  chef_strings              = "${local.chef_strings}"
  chef_lists                = "${local.chef_lists}"
  chef_iam_policy_count     = "${module.chef.iam_policy_count}"
  terraform_strings         = "${local.terraform_strings}"
  tags                      = "${local.tags}"
}
output "cluster_internal_cnames" { value = "${module.cluster.internal_cnames}" }
