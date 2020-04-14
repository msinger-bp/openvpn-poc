locals {
  mount_point_mysql_data            = "${var.env_strings["ebs_vol_mount_root"]}/mysql/data"
}
output "mount_point_mysql_data" { value = "${local.mount_point_mysql_data}" }

module "cluster" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//ec2/cluster.private.per-az/3-az/0.1.9"
  name                              = "${var.name}"
  subnet_group_octet                = "${var.subnet_group_octet}"
  az_0_instance_count               = "${var.instance_count_az0}"
  az_1_instance_count               = "${var.instance_count_az1}"
  az_2_instance_count               = "${var.instance_count_az2}"
  instance_type                     = "${var.instance_type}"
  ami_id                            = "${ coalesce( var.ami_id,                             var.base_strings["default_ami_id"] ) }"
  root_volume_size                  = "${ coalesce( var.root_volume_size,                   var.env_strings["default_root_volume_size"]                   ) }"
  root_volume_type                  = "${ coalesce( var.root_volume_type,                   var.env_strings["default_root_volume_type"]                   ) }"
  root_volume_iops                  = "${ coalesce( var.root_volume_iops,                   var.env_strings["default_root_volume_iops"]                   ) }"
  root_volume_delete_on_termination = "${ coalesce( var.root_volume_delete_on_termination,  var.env_strings["default_root_volume_delete_on_termination"]  ) }"
  addl_security_groups              = [ "${ concat( var.addl_security_groups, list(var.vpc_strings["admin-access_sg_id"]) ) }" ]
  ##  NON-ROOT EBS VOLUME CONFIG - SEE INSTRUCTIONS IN ebs-vols/resources.ebs.vols.tf
  az_0_ebs_vol_config_string_list   = "${module.galera_ebs_vols_az0.ebs_vol_config_string_list}"
  az_0_ebs_vol_config_string_count  = "${module.galera_ebs_vols_az0.ebs_vol_config_string_count}"
  az_1_ebs_vol_config_string_list   = "${module.galera_ebs_vols_az1.ebs_vol_config_string_list}"
  az_1_ebs_vol_config_string_count  = "${module.galera_ebs_vols_az1.ebs_vol_config_string_count}"
  az_2_ebs_vol_config_string_list   = "${module.galera_ebs_vols_az2.ebs_vol_config_string_list}"
  az_2_ebs_vol_config_string_count  = "${module.galera_ebs_vols_az2.ebs_vol_config_string_count}"
  ephemeral_vol_config_string       = "mysql-data:${local.mount_point_mysql_data}:xfs" ##  MYSQL DATA DIR IS AN EPHEMERAL VOLUME
  addl_iam_policy_arns              = "${ concat( var.chef_lists["iam_policy_arns"], var.addl_iam_policy_arns ) }"
  addl_iam_policy_count             = "2" ##  THIS MUST BE MANUALLY TALLIED AND AN INTEGER ENTERED HERE
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  ec2_key                           = "${var.env_strings["ec2_key"]}"
  vpc_id                            = "${var.vpc_strings["id"]}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  az_count                          = "${var.az_count}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  internal_zone_id                  = "${var.vpc_strings["internal_zone_id"]}"
  nat_gw_private_route_table_ids    = "${var.vpc_lists["nat_gw_private_route_table_ids"]}"
  chef_role                         = "${ coalesce( var.chef_role, var.name ) }"
  chef_strings                      = "${var.chef_strings}"
  tf_state_vars                     = "${var.terraform_strings}"
  tags                              = "${var.tags}"
}

output "instance_ids_az0"           { value = "${module.cluster.az_0_instance_ids}" }
output "instance_ids_az1"           { value = "${module.cluster.az_1_instance_ids}" }
output "instance_ids_az2"           { value = "${module.cluster.az_2_instance_ids}" }
output "instance_ids_all"           { value = "${module.cluster.all_instance_ids}" }

output "instance_ips_az0"           { value = "${module.cluster.az_0_instance_private_ip_addresses}" }
output "instance_ips_az1"           { value = "${module.cluster.az_1_instance_private_ip_addresses}" }
output "instance_ips_az2"           { value = "${module.cluster.az_2_instance_private_ip_addresses}" }
output "instance_ips_all"           { value = "${module.cluster.all_instance_ip_addresses}" }

output "internal_cnames_long_az0"   { value = "${module.cluster.az_0_internal_cnames_long}" }
output "internal_cnames_long_az1"   { value = "${module.cluster.az_1_internal_cnames_long}" }
output "internal_cnames_long_az2"   { value = "${module.cluster.az_2_internal_cnames_long}" }
output "internal_cnames_long_all"   { value = "${module.cluster.all_internal_cnames_long}" }

output "internal_cnames_short_az0"  { value = "${module.cluster.az_0_internal_cnames_short}" }
output "internal_cnames_short_az1"  { value = "${module.cluster.az_1_internal_cnames_short}" }
output "internal_cnames_short_az2"  { value = "${module.cluster.az_2_internal_cnames_short}" }
output "internal_cnames_short_all"  { value = "${module.cluster.all_internal_cnames_short}" }

output "galera_sg_id"               { value = "${module.cluster.sg_id}" }
