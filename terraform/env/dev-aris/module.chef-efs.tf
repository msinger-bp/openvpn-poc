module "chef-efs" {
  source = "../../site-modules/chef-efs/0.2.0"

  env_strings  = "${local.env_strings}"
  base_strings = "${local.base_strings}"
  vpc_strings  = "${local.vpc_strings}"
  vpc_lists    = "${local.vpc_lists}"
  tags         = "${local.tags}"

  #TF12
  # env = module.env
  # base = module.base
  # vpc = module.vpc_main

  efs_mount_dir             = "${var.chef_efs_mount_dir}"
  efs_subnet_group_octet    = "3"
  loader_subnet_group_octet = "4"
}

# TODO(TF12): Replace with direct module pass-thru
locals {
  # TODO: Follow-up on Chef user-data usage  # chef_strings = {  #   user_data_template = "${file("${path.module}/files/chef-client-user-data.tpl")}"  # }
  # TODO: Remove redundant prefixes and replace "-" with "_"
  chef_strings = {
    chef_repo             = "${var.chef_repo}"
    chef-efs_mount_dir    = "/var/chef"                                             # TODO: Output from chef module
    chef-efs_mount_target = "${module.chef-efs.chef-efs_mount_target_dns_names[0]}"
    chef_environment      = "${var.chef_environment}"
  }

  chef_lists = {
    # mount_names = "${module.chef-efs.chef-efs_mount_target_dns_names}"
  }
}

#output "chef-efs_vol_id"                    { value = "${module.chef-efs.chef-efs_vol_id}" }
#output "chef-efs_vol_arn"                   { value = "${module.chef-efs.chef-efs_vol_arn}" }
#output "chef-efs_vol_dns_name"              { value = "${module.chef-efs.chef-efs_vol_dns_name}" }
#output "chef-efs_mount_target_dns_names"    { value = "${module.chef-efs.chef-efs_mount_target_dns_names}" }

