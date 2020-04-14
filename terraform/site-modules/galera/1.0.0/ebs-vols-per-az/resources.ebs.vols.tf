########################################################
##
##  EBS VOLUMES
##

##  USE THIS TEMPLATE FILE TO CREATE AN ARBITRARY SET OF
##  EBS VOLUMES, ATTACH THEM TO A SET OF EC2 INSTANCES
##  CREATED BY A CLUSTER MODULE, AND CONTROL THEIR
##  AUTOMATIC MOUNTING AND FORMATTING ON THE INSTANCE
##  BY THE USER DATA SCRIPT

##  TO ADD AN EBS VOLUME:
##    1. COPY A MODULE INSTANTIATION STANZA BELOW
##    2. MODIFY THE MODULE AS REQUIRED
##       2.1. 'vol_name', 'vol_label', 'device_id', AND 'mount_point' MUST BE UNIQUE
##       2.2. CONFIGURE 'ebs_type', 'iops', 'snapshot_id', 'size', 'encrypted', AND 'fs' AS REQUIRED (SEE NOTES BELOW)
##    3. IN 'data "template_file" "ebs_vol_config_string_list"' BELOW, ADD A REFERENCE TO THE NEW MODULE / EBS VOLUME IN THE TEMPLATE LIST
##    4. ADD A PARAMETER TO YOUR INSTANCE CLUSTER MODULE LIKE THIS:
##       ebs_vol_config_string_list = "${data.template_file.ebs_vol_config_string_list.*.rendered}"
##    5. THE LOCAL VARIABLE 'ebs_vol_config_string_count' MUST BE MANUALLY SET TO THE TOTAL NUMBER OF EBS VOLUMES / MODULES
##       BECAUSE OF TF11 BUGS, IT CANNOT BE AUTOMATICALLY COMPUTED!

locals {
  ebs_vol_config_string_count = "2"
}
output "ebs_vol_config_string_count" { value = "${local.ebs_vol_config_string_count}" }

##  NOTE: THIS IS THE MAGIC HACK THAT GETS THE INDEXED VOLUME ID ELEMENT
##  OUT OF EACH EBS VOLUME ID LIST AND ALLOWS THAT LIST TO BE INSERTED
##  INTO THE INSTANCE USER DATA SCRIPT
data "template_file" "ebs_vol_config_string_list" {
  count         = "${var.instance_count}"
  template      = "${
    join(
      ";",
      list(
        "${element(module.volume_1.volume_details_ids_list, count.index)}",
        "${element(module.volume_2.volume_details_ids_list, count.index)}"
      )
    )
  }"
}
output "ebs_vol_config_string_list" { value = "${data.template_file.ebs_vol_config_string_list.*.rendered}" }

module "volume_1" {

  ##  THESE SHOULD BE THE SAME FOR EACH MODULE INVOCATIONS IN THIS MODULE
  source        = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//ec2/ebs.vol.attach/0.1.3"
  count         = "${var.instance_count}"
  instance_ids  = "${var.instance_ids}"
  az_list       = "${list(var.az)}"
  name          = "${var.name}"
  org           = "${var.env_strings["org"]}"
  env           = "${var.env_strings["env"]}"
  tags          = "${var.tags}"
  kms_key_arn   = "${var.kms_key_arn}"

  ##  EBS VOLUME CONFIGURATION
  size          = "${var.volume_1_size}"
  ebs_type      = "${var.volume_1_type}"
  iops          = "${var.volume_1_iops}"
  device_id     = "${var.volume_1_device_id}"
  encrypted     = "${var.volume_1_encrypted}"
  vol_name      = "${var.volume_1_vol_name}"
  vol_label     = "${var.volume_1_vol_label}"
  mount_point   = "${var.volume_1_mount_point}"
  fs_type       = "${var.volume_1_fs}"

}

module "volume_2" {

  ##  THESE SHOULD BE THE SAME FOR EACH MODULE INVOCATIONS IN THIS MODULE
  source        = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//ec2/ebs.vol.attach/0.1.3"
  count         = "${var.instance_count}"
  instance_ids  = "${var.instance_ids}"
  az_list       = "${list(var.az)}"
  name          = "${var.name}"
  org           = "${var.env_strings["org"]}"
  env           = "${var.env_strings["env"]}"
  tags          = "${var.tags}"
  kms_key_arn   = "${var.kms_key_arn}"

  ##  EBS VOLUME CONFIGURATION
  size          = "${var.volume_2_size}"
  ebs_type      = "${var.volume_2_type}"
  iops          = "${var.volume_2_iops}"
  device_id     = "${var.volume_2_device_id}"
  encrypted     = "${var.volume_2_encrypted}"
  vol_name      = "${var.volume_2_vol_name}"
  vol_label     = "${var.volume_2_vol_label}"
  mount_point   = "${var.volume_2_mount_point}"
  fs_type       = "${var.volume_2_fs}"

}
