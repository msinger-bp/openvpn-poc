module "data_volume" {
  source        = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//ec2/ebs.vol.attach/0.1.3"
  count         = "${var.instance_count}"
  instance_ids  = "${var.instance_ids}"
  az_list       = "${list(var.az)}"
  name          = "${var.name}"
  org           = "${var.env_strings["org"]}"
  env           = "${var.env_strings["env"]}"
  tags          = "${var.tags}"
  vol_name      = "data"
  vol_label     = "data"
  mount_point   = "${var.data_volume_mount_point}"
  device_id     = "/dev/sdf"
  ebs_type      = "${var.data_volume_type}"
  iops          = "${var.data_volume_iops}"
  size          = "${var.data_volume_size}"
  encrypted     = "true"
  kms_key_arn   = "${var.kms_key_arn}"
  fs_type       = "ext4"
}
data "template_file" "ebs_vol_config_string_list" {
  count         = "${var.instance_count}"
  template      = "${ join( ";", list(
    "${element(module.data_volume.volume_details_ids_list, count.index)}"
  ) ) }" }
output "ebs_vol_config_string_list" { value = "${data.template_file.ebs_vol_config_string_list.*.rendered}" }
output "ebs_vol_config_string_count" { value = "1"}
