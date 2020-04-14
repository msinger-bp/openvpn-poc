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
##       2.2. CONFIGURE 'ebs_type', 'iops', 'snapshot_id', 'size', 'encrypted', AND 'fs_type' AS REQUIRED (SEE NOTES BELOW)
##    3. ADD A REFERENCE TO THE NEW MODULE / EBS VOLUME
##       IN THE DATA TEMPLATE LIST BELOW
##    4. ADD A PARAMETER TO YOUR INSTANCE CLUSTER MODULE LIKE THIS:
##       ebs_vol_config_string_list = "${data.template_file.ebs_vol_config_string_list.*.rendered}"
##    5. THE LOCAL VARIABLE 'ebs_vol_config_string_count' MUST EQUAL THE TOTAL NUMBER OF EBS VOLUMES

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
        "${element(module.data_volume.volume_details_ids_list, count.index)}",
        "${element(module.logs_volume.volume_details_ids_list, count.index)}"
      )
    )
  }"
}
output "ebs_vol_config_string_list" { value = "${data.template_file.ebs_vol_config_string_list.*.rendered}" }

##  DATA VOLUME
module "data_volume" {
  ##  TF PARAMETERS - THESE SHOULD BE THE SAME FOR EACH EBS VOLUME
  source        = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//ec2/ebs.vol.attach/0.1.3"
  count         = "${var.instance_count}"
  instance_ids  = "${var.instance_ids}"
  az_list       = "${list(var.az)}"

  ##  THESE ARE ONLY USED FOR EBS VOLUME NAME TAG
  name          = "${var.name}"
  #org           = "${var.env_strings["org"]}"
  #env           = "${var.env_strings["env"]}"
  org           = "${var.org}"
  env           = "${var.env}"
  tags          = "${var.tags}"

  ##  UNIQUE VOLUME PARAMETERS
  vol_name      = "data"      ##  USED FOR NAME TAG
  vol_label     = "data"      ##  MUST BE UNIQUE, USED BY mount.ebs.vols.sh TO SET VOLUME LABEL AND FSTAB RECORD
  mount_point   = "/mnt/data" ##  MUST BE UNIQUE, mount.ebs.vols.sh WILL CREATE THIS DIR AND MOUNT THE VOLUME THERE

  ##  VOLUME DEVICE ID IS IGNORED FOR NITRO/NVME-BASED INSTANCE TYPES
  ##  IN FACT, WE DON'T CURRENLTY SUPPORT EBS VOLUMES FOR NON-NVME-BASED INSTANCE TYPES
  ##  HOWEVER, IT MUST BE PRESENT AND A VALID, UNIQUE DEVICE ID FOR EACH EBS VOLUME
  ##  YOU CAN USE '/dev/sd[b-z]', BUT AWS RECOMMENDS '/dev/sd[f-p]' BECAUSE INSTANCE STORE VOLUMES MIGHT BE '/dev/sd[b-e]'
  ##  https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html
  device_id     = "/dev/sdf"

  ##  EBS VOLUME CONFIGURATION
  ebs_type      = "gp2"                 ##  DEFAULT gp2
  iops          = 100                   ##  POSITIVE INTEGER ; MIN 100 ; DEFAULT 100 ; IOPS/SIZE MAX RATIO 50
  snapshot_id   = ""                    ##  DEFAULT EMPTY (FRESH, UNFORMATTED VOLUME)
  size          = 5                     ##  GB
  encrypted     = "true"                ##  DEFAULT false
  kms_key_arn   = "${var.kms_key_arn}"  ##  USE CUSTOMER-MANAGED KMS KEY (CMK), IF PROVIDED; OTHERWISE, USE AWS-MANAGED KMS KEY
  fs_type       = "ext4"                ##  USER DATA SCRIPT USES THIS TO FORMAT THE VOLUME
}

##  LOGS VOLUME
module "logs_volume" {
  source        = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//ec2/ebs.vol.attach/0.1.3"
  count         = "${var.instance_count}"
  instance_ids  = "${var.instance_ids}"
  az_list       = "${list(var.az)}"
  name          = "${var.name}"
  #org           = "${var.env_strings["org"]}"
  #env           = "${var.env_strings["env"]}"
  org           = "${var.org}"
  env           = "${var.env}"
  tags          = "${var.tags}"
  vol_name      = "logs"
  vol_label     = "logs"
  mount_point   = "/mnt/logs"
  fs_type       = "ext4"
  ebs_type      = "io1"
  iops          = 200
  size          = 10
  device_id     = "/dev/sdh"
}
