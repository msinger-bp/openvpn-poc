##  CHEF
##
##  CREATES THE EFS VOLUME FOR CENTRALIZED CHEF CONFIG AND NODE INFO
##
##  ALSO CREATES AN EC2 'LOADER' INSTANCE FOR INITIAL CLONING OF THE GIT REPO INTO THE EFS VOLUME

module "chef" {
  source                                = "../../site-modules/chef/0.3.1"
  name                                  = "chef"
  env_strings                           = "${local.env_strings}"
  base_strings                          = "${local.base_strings}"
  terraform_strings                     = "${local.terraform_strings}"
  vpc_strings                           = "${local.vpc-main_strings}"
  vpc_lists                             = "${local.vpc-main_lists}"
  az_count                              = "${var.vpc-main_az_count}"
  tags                                  = "${local.tags}"
  efs-vol_subnet_group_octet            = "${var.subnet_group_octets["chef-efs-vol"]}"
  loader-instance_subnet_group_octet    = "${var.subnet_group_octets["chef-loader-instance"]}"
}

locals {
  chef_strings                          = {
    chef_repo                           = "${var.chef_repo}"
    chef_mount_dir                      = "${module.chef.efs_mount_dir}"
    chef_mount_target                   = "${module.chef.efs-vol_mount_target_dns_names[0]}"
    chef_environment                    = "${var.chef_environment}"
  }
  chef_lists                            = {
    iam_policy_arns                     = [
      "${module.chef.iam_policy_s3-tfstate-ro}",
      "${module.chef.iam_policy_ddb-tfstate-lock-ro_arn}",
    ]
  }
}

output "chef_efs_vol_mount_target" { value = "${module.chef.efs-vol_mount_target_dns_names[0]}" }
