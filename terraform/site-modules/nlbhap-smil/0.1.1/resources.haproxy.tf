###########################################################
##
##  HAPROXY RESOURCES
##
module "haproxy" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//ec2/cluster.private.per-az/3-az/0.1.9"
  name                              = "${var.name}-haproxy"
  subnet_group_octet                = "${var.subnet_group_octet_haproxy}"
  az_0_instance_count               = "${var.instance_count_az0}"
  az_1_instance_count               = "${var.instance_count_az1}"
  az_2_instance_count               = "${var.instance_count_az2}"
  placement_group_strategy          = "${var.placement_group_strategy}"
  instance_type                     = "${ coalesce( var.instance_type, var.env_strings["default_ec2_instance_type"] ) }"
  root_volume_size                  = "${ coalesce( var.root_volume_size, var.env_strings["default_root_volume_size"] ) }"
  root_volume_type                  = "${ coalesce( var.root_volume_type, var.env_strings["default_root_volume_type"] ) }"
  root_volume_iops                  = "${ coalesce( var.root_volume_iops, var.env_strings["default_root_volume_iops"] ) }"
  az_0_ebs_vol_config_string_list   = "${module.ebs_volumes_az0.ebs_vol_config_string_list}"
  az_0_ebs_vol_config_string_count  = "${module.ebs_volumes_az0.ebs_vol_config_string_count}"
  az_1_ebs_vol_config_string_list   = "${module.ebs_volumes_az1.ebs_vol_config_string_list}"
  az_1_ebs_vol_config_string_count  = "${module.ebs_volumes_az1.ebs_vol_config_string_count}"
  az_2_ebs_vol_config_string_list   = "${module.ebs_volumes_az2.ebs_vol_config_string_list}"
  az_2_ebs_vol_config_string_count  = "${module.ebs_volumes_az2.ebs_vol_config_string_count}"
  ami_id                            = "${ coalesce( var.ami_id, var.base_strings["default_ami_id"] ) }"
  addl_security_groups              = [ "${ concat( var.addl_security_groups, list(var.vpc_strings["admin-access_sg_id"]) ) }" ]
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  ec2_key                           = "${var.env_strings["ec2_key"]}"
  addl_iam_policy_arns              = "${ concat( var.chef_lists["iam_policy_arns"], var.addl_iam_policy_arns ) }"
  addl_iam_policy_count             = "${var.chef_iam_policy_count + length( var.addl_iam_policy_arns ) }"
  vpc_id                            = "${var.vpc_strings["id"]}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  az_count                          = "${var.az_count}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  internal_zone_id                  = "${var.vpc_strings["internal_zone_id"]}"
  nat_gw_private_route_table_ids    = "${var.vpc_lists["nat_gw_private_route_table_ids"]}"
  tags                              = "${var.tags}"
  chef_role                         = "${ coalesce( var.chef_role, "${var.name}-haproxy" ) }"
  chef_strings                      = "${var.chef_strings}"
  tf_state_vars                     = "${var.terraform_strings}"
}
#output "instance_ids"                   { value = "${module.haproxy.instance_ids}" }
#output "instance_private_ip_addresses"  { value = "${module.haproxy.instance_private_ip_addresses}" }
#output "internal_cnames"                { value = "${module.haproxy.internal_cnames_long}" }
#output "sg_id"                          { value = "${module.haproxy.sg_id}" }

output "instance_ids_az0"                   { value = "${module.haproxy.az_0_instance_ids}" }
output "instance_private_ip_addresses_az0"  { value = "${module.haproxy.az_0_instance_private_ip_addresses}" }
output "internal_cnames_short_az0"          { value = "${module.haproxy.az_0_internal_cnames_short}" }
output "internal_cnames_long_az0"           { value = "${module.haproxy.az_0_internal_cnames_long}" }
output "instance_ids_az1"                   { value = "${module.haproxy.az_1_instance_ids}" }
output "instance_private_ip_addresses_az1"  { value = "${module.haproxy.az_1_instance_private_ip_addresses}" }
output "internal_cnames_short_az1"          { value = "${module.haproxy.az_1_internal_cnames_short}" }
output "internal_cnames_long_az1"           { value = "${module.haproxy.az_1_internal_cnames_long}" }
output "instance_ids_az2"                   { value = "${module.haproxy.az_2_instance_ids}" }
output "instance_private_ip_addresses_az2"  { value = "${module.haproxy.az_2_instance_private_ip_addresses}" }
output "internal_cnames_short_az2"          { value = "${module.haproxy.az_2_internal_cnames_short}" }
output "internal_cnames_long_az2"           { value = "${module.haproxy.az_2_internal_cnames_long}" }
output "instance_ids_all"                   { value = "${module.haproxy.all_instance_ids}" }
output "instance_ip_addresses_all"          { value = "${module.haproxy.all_instance_ip_addresses}" }
output "internal_cnames_long_all"           { value = "${module.haproxy.all_internal_cnames_long}" }
output "sg_id"                              { value = "${module.haproxy.sg_id}" }
