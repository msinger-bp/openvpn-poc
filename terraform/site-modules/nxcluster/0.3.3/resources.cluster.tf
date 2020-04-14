##  EC2 INSTANCE CLUSTER
module "cluster" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//ec2/cluster.private.per-az/3-az/0.1.7"
  ##  UNIQUE NAME FOR RESOURCES, TAGS, ETC - GENERALLY THE SAME AS THE SITE-MODULE
  name                              = "${var.name}"
  ##  SUBNET OCTET IN WHICH TO PLACE INSTANCES
  subnet_group_octet                = "${var.subnet_group_octet}"
  ##  INSTANCE COUNTS PER AZ
  az_0_instance_count               = "${var.az_0_instance_count}"
  az_1_instance_count               = "${var.az_1_instance_count}"
  az_2_instance_count               = "${var.az_2_instance_count}"
  placement_group_strategy          = "${var.placement_group_strategy}"
  ##  INSTANCE CONFIG
  ami_id                            = "${ coalesce( var.ami_id, var.base_strings["default_ami_id"] ) }"
  instance_type                     = "${ coalesce( var.instance_type, var.env_strings["default_ec2_instance_type"] ) }"
  ##  ROOT VOLUME CONFIG
  root_volume_size                  = "32"
  root_volume_type                  = "gp2" ## DEFAULT 'standard'
  root_volume_iops                  = ""    ## MUST BE SPECIFIED IF TYPE = io1
  root_volume_delete_on_termination = "${ coalesce( var.root_volume_delete_on_termination,  var.env_strings["default_root_volume_delete_on_termination"]  ) }"
  ##  CHEF INTEGRATION
  chef_role                         = "${ coalesce( var.chef_role, var.name ) }"
  chef_strings                      = "${var.chef_strings}"
  tf_state_vars                     = "${var.terraform_strings}"
  ##  EPHEMERAL VOLUME CONFIG
  ephemeral_vol_config_string       = "ephemeral:/mnt/ephemeral:ext4"
  ##  NON-ROOT EBS VOLUME CONFIG - SEE INSTRUCTIONS IN ebs-vols/resources.ebs.vols.tf
  az_0_ebs_vol_config_string_list   = "${module.az_0_volumes.ebs_vol_config_string_list}"
  az_0_ebs_vol_config_string_count  = "${module.az_0_volumes.ebs_vol_config_string_count}"
  az_1_ebs_vol_config_string_list   = "${module.az_1_volumes.ebs_vol_config_string_list}"
  az_1_ebs_vol_config_string_count  = "${module.az_1_volumes.ebs_vol_config_string_count}"
  az_2_ebs_vol_config_string_list   = "${module.az_2_volumes.ebs_vol_config_string_list}"
  az_2_ebs_vol_config_string_count  = "${module.az_2_volumes.ebs_vol_config_string_count}"
  ## ENVIRONMENT
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  ec2_key                           = "${var.env_strings["ec2_key"]}"
  tags                              = "${var.tags}"
  ##  VPC
  vpc_id                            = "${var.vpc_strings["id"]}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  az_count                          = "${var.az_count}"
  nat_gw_private_route_table_ids    = "${var.vpc_lists["nat_gw_private_route_table_ids"]}"
  ##  INTERNAL DNS
  internal_zone_id                  = "${var.vpc_strings["internal_zone_id"]}"
  ##  ADDITIONAL SECURITY GROUPS TO ATTACH TO INSTANCES
  addl_security_groups              = [ "${var.vpc_strings["admin-access_sg_id"]}" ]   ##  ALLOW ACCESS FROM ADMIN SYSTEMS (BASTION, MONITORING, ETC)
  ##  ADDITIONAL IAM POLICIES TO ATTACH TO INSTANCE IAM ROLE
  addl_iam_policy_arns              = "${ concat( var.chef_lists["iam_policy_arns"], var.addl_iam_policy_arns ) }"
  addl_iam_policy_count             = "2" ##  MANUALLY CALCULATED INTEGER (B/C TF11): var.chef_lists["iam_policy_arns"] CONTAINS 2 POLICY ARNS
}
output "az_0_instance_ids"                  { value = "${module.cluster.az_0_instance_ids}" }
output "az_0_instance_private_ip_addresses" { value = "${module.cluster.az_0_instance_private_ip_addresses}" }
output "az_0_internal_cnames_short"         { value = "${module.cluster.az_0_internal_cnames_short}" }
output "az_0_internal_cnames_long"          { value = "${module.cluster.az_0_internal_cnames_long}" }
output "az_1_instance_ids"                  { value = "${module.cluster.az_1_instance_ids}" }
output "az_1_instance_private_ip_addresses" { value = "${module.cluster.az_1_instance_private_ip_addresses}" }
output "az_1_internal_cnames_short"         { value = "${module.cluster.az_1_internal_cnames_short}" }
output "az_1_internal_cnames_long"          { value = "${module.cluster.az_1_internal_cnames_long}" }
output "az_2_instance_ids"                  { value = "${module.cluster.az_2_instance_ids}" }
output "az_2_instance_private_ip_addresses" { value = "${module.cluster.az_2_instance_private_ip_addresses}" }
output "az_2_internal_cnames_short"         { value = "${module.cluster.az_2_internal_cnames_short}" }
output "az_2_internal_cnames_long"          { value = "${module.cluster.az_2_internal_cnames_long}" }
output "all_instance_ids"                   { value = "${module.cluster.all_instance_ids}" }
output "all_instance_ip_addresses"          { value = "${module.cluster.all_instance_ip_addresses}" }
output "all_internal_cnames_long"           { value = "${module.cluster.all_internal_cnames_long}" }
output "sg_id"                              { value = "${module.cluster.sg_id}" }
