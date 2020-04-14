##  NXCLUSTER EC2 CLUSTER
##
##    * USES "cluster.private.per-az" LIBRARY MODULE
##      * ALLOWS SPECIFYING A SEPARATE INSTANCE COUNT PER AZ
##      * IDENTIFIES THE AZ IN THE HOSTNAME/CNAME/TAG
##
##    * DEMONSTRATES USING THE 'ebs.vol.attach' LIBRARY MODULE
##      * ALLOWS CONFIGURATION OF AN ARBITRARY SET OF EBS VOLS,
##        ATTACHMENT TO INSTANCES, FORMATTING, AND MOUNTING
##
module "cluster" {
  source                    = "../../site-modules/nxcluster/0.3.2"
  name                      = "cluster"
  subnet_group_octet        = "${var.subnet_group_octets["cluster"]}"
  az_0_instance_count       = "1"
  az_1_instance_count       = "2"
  az_2_instance_count       = "3"
  placement_group_strategy  = "cluster"   ##  CAN BE "cluster" OR "spread"
  instance_type             = "c5d.large" ##  TO SUPPORT NVME LOCAL/EPHEMERAL SSD VOLUMES
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
output "cluster_instance_ids"             { value = "${module.cluster.all_instance_ids}" }
output "cluster_instance_ip_addresses"    { value = "${module.cluster.all_instance_ip_addresses}" }
output "cluster_internal_cnames_long"     { value = "${module.cluster.all_internal_cnames_long}" }
