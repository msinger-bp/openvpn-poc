module "efs-vol" {
  source                         = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//efs/0.1.0"
  name                           = "${var.name}"
  subnet_group_octet             = "${var.subnet_group_octet}"
  org                            = "${var.env_strings["org"]}"
  env                            = "${var.env_strings["env"]}"
  ec2_key                        = "${var.env_strings["ec2_key"]}"
  tags                           = "${var.tags}"
  vpc_id                         = "${var.vpc_strings["id"]}"
  vpc_cidr_16                    = "${var.vpc_strings["cidr_16"]}"
  az_list                        = "${var.vpc_lists["availability_zones"]}"
  az_count                       = "${var.az_count}"
  nat_gw_private_route_table_ids = "${var.vpc_lists["nat_gw_private_route_table_ids"]}"
  internal_zone_id               = "${var.vpc_strings["internal_zone_id"]}"
}

output "efs-vol_sg_id"                  { value = "${module.efs-vol.sg_id}" }
output "efs-vol_id"                     { value = "${module.efs-vol.vol_id}" }
output "efs-vol_arn"                    { value = "${module.efs-vol.vol_arn}" }
output "efs-vol_dns_name"               { value = "${module.efs-vol.vol_dns_name}" }
output "efs-vol_mount_target_ids"       { value = "${module.efs-vol.mount_target_ids}" }
output "efs-vol_mount_target_dns_names" { value = "${module.efs-vol.mount_target_dns_names}" }
