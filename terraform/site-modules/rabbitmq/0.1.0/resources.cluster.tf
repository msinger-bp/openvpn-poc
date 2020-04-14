module "cluster" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//ec2/cluster.private/0.1.11"
  name                              = "${var.name}"
  subnet_group_octet                = "${var.subnet_group_octet}"
  instance_count                    = "${var.instance_count}"
  ami_id                            = "${local.ami_id}"
  instance_type                     = "${local.instance_type}"
  addl_security_groups              = [ "${var.vpc_strings["admin-access_sg_id"]}" ]   ##  ALLOW ACCESS FROM ADMIN SYSTEMS (BASTION, MONITORING, ETC)
  ebs_vol_config_string_list        = "${data.template_file.all_ebs_volume_detail_id_lists.*.rendered}"
  ebs_vol_config_string_count       = "${local.ebs_vol_config_string_count}"
  ephemeral_vol_config_string       = "ephemeral:/mnt/ephemeral:ext4"           ##  '<EPHEMERAL_VOL_LABEL>:<MOUNT_POINT>:<FS_TYPE>'
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  ec2_key                           = "${var.env_strings["ec2_key"]}"
  addl_iam_policy_arns              = "${concat(
    var.chef_lists["iam_policy_arns"],
    var.addl_iam_policy_arns
  )}"
  ## PITA, BUT WITH TF11, YOU HAVE TO MANUALLY COUNT LISTS
  addl_iam_policy_count             = "${var.chef_iam_policy_count}"
  vpc_id                            = "${var.vpc_strings["id"]}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  az_count                          = "${var.az_count}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  internal_zone_id                  = "${var.vpc_strings["internal_zone_id"]}"
  nat_gw_private_route_table_ids    = "${var.vpc_lists["nat_gw_private_route_table_ids"]}"
  tags                              = "${var.tags}"
  ##  CHEF INTEGRATION
  chef_role                         = "${local.chef_role}"
  chef_strings                      = "${var.chef_strings}"
  tf_state_vars                     = "${var.terraform_strings}"
}
output "instance_ids"                   { value = "${module.cluster.instance_ids}" }
output "instance_private_ip_addresses"  { value = "${module.cluster.instance_private_ip_addresses}" }
output "internal_cnames"                { value = "${module.cluster.internal_cnames_long}" }
output "sg_id"                          { value = "${module.cluster.sg_id}" }

