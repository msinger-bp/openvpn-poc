########################################################
##
##  EBS VOLUMES
##

##  USE THIS TEMPLATE FILE TO CREATE AN ARBITRARY SET OF EBS VOLUMES, ATTACH THEM TO AN EC2 INSTANCE CLUSTER,
##  AND CONTROL THEIR AUTOMATIC MOUNTING AND FORMATTING ON THE INSTANCE BY THE USER DATA SCRIPT

##  TO ADD AN EBS VOLUME:
##    1. COPY A MODULE INSTANTIATION STANZA BELOW
##    2. MODIFY THE MODULE AS REQUIRED
##       2.1. 'vol_name', 'vol_label', 'device_id', AND 'mount_point' MUST BE UNIQUE
##       2.2. CONFIGURE 'ebs_type', 'iops', 'snapshot_id', 'size', 'encrypted', AND 'fs_type' AS REQUIRED
##    3. ADD A REFERENCE TO THE NEW MODULE / EBS VOLUME IN THE 'all_ebs_volume_detail_id_lists' DATA TEMPLATE_FILE LIST BELOW
##    4. THE LOCAL VARIABLE 'ebs_vol_config_string_count' MUST EQUAL THE TOTAL NUMBER OF EBS VOLUMES
##    5. ADD THESE PARAMETERS TO YOUR INSTANCE CLUSTER MODULE:
##       ebs_vol_config_string_list   = "${data.template_file.all_ebs_volume_detail_id_lists.*.rendered}"
##       ebs_vol_config_string_count  = "${local.ebs_vol_config_string_count}"

locals {
  ebs_vol_config_string_count = "1"
}

##  CUSTOMER-MANAGED KMS KEY, IF REQUIRED
resource "aws_kms_key" "ebs-volumes" {
  description   = "${local.org_env_name}"
  tags          = "${local.tags_w_name}"
}

##  NOTE: THIS IS THE MAGIC HACK THAT GETS THE INDEXED VOLUME ID ELEMENT
##  OUT OF EACH EBS VOLUME ID LIST AND ALLOWS THAT LIST TO BE INSERTED
##  INTO THE INSTANCE USER DATA SCRIPT
data "template_file" "all_ebs_volume_detail_id_lists" {
  count         = "${var.instance_count}"
  template      = "${
    join(
      ";",
      list(
        "${element(module.srv.volume_details_ids_list, count.index)}"
      )
    )
  }"
}

##  GP2, 5GB, ENCRYPTED WITH PROVIDED (CUSTOMER-MANAGED) KMS KEY
module "srv" {
  ##  TF PARAMETERS - THESE SHOULD BE THE SAME FOR EACH EBS VOLUME
  source        = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//ec2/ebs.vol.attach/0.1.3"
  count         = "${var.instance_count}"
  instance_ids  = "${module.cluster.instance_ids}"
  az_list       = "${var.vpc_lists["availability_zones"]}"
  ##  ENV VARS ONLY USED FOR EBS VOLUME NAME TAG
  name          = "${var.name}"
  org           = "${var.env_strings["org"]}"
  env           = "${var.env_strings["env"]}"
  tags          = "${var.tags}"
  ##  EBS VOLUME CONFIGURATION
  size          = "${var.data_volume_size}"        ##  GB
  ebs_type      = "gp2"                            ##  DEFAULT gp2
  #snapshot_id  = "<pre-existing_ebs_snapshot_id>" ##  DEFAULT EMPTY (FRESH, UNFORMATTED VOLUME)
  encrypted     = true                             ##  DEFAULT false
  kms_key_arn   = "${aws_kms_key.ebs-volumes.arn}" ##  USE CUSTOMER-MANAGED KMS KEY (CMK), IF PROVIDED; OTHERWISE, USE AWS-MANAGED KMS KEY
  ##  DEVICE ID MUST BE PRESENT AND A VALID, UNIQUE DEVICE ID FOR EACH EBS VOLUME
  ##  DEVICE ID IS IGNORED FOR NON-NVME-BASED INSTANCE TYPES
  ##  IN FACT, WE DON'T CURRENTLY SUPPORT NON-NVME-BASED INSTANCE TYPES
  device_id     = "/dev/sdd"
  ##  VOLUME NAME / LABEL / MOUNT POINT / FS TYPE
  ##  THESE PARAMETERS ARE PROVIDED TO AND USED BY THE CLOUD-INIT SCRIPT TO FORMAT AND PERSISTENTLY MOUNT THE VOLUME
  vol_name      = "srv"      ##  IGNORED
  vol_label     = "srv"      ##  MUST BE UNIQUE
  fs_type       = "ext4"
  mount_point   = "/mnt/srv" ##  MUST BE UNIQUE
}
