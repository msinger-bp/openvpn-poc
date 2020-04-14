##  terraform/site-modules/cluster1/<version>/resources.ebs.volumes.tf

##  KMS KEY FOR ALL EBS VOLUMES IN THIS CLUSTER
resource "aws_kms_key" "ebs-volumes" {
  description   = "${local.org_env_name}"
  tags          = "${local.tags_w_name}"
}

locals {
  ebs_vol_config_string_count = "2"
}

data "template_file" "all_ebs_volume_detail_id_lists" {
  count         = "${var.instance_count}"
  template      = "${ join( ";", list(
        "${element(local.data_vol_details_ids_list, count.index)}",
        "${element(local.log_vol_details_ids_list, count.index)}"
  ) ) }"
}


############################################################
##
##  DATA VOLUME
##

locals {
  data_vol_type           = "${ coalesce( var.data_vol_type, var.env_strings["default_data_volume_type"] ) }"
  data_vol_size           = "${ coalesce( var.data_vol_size, var.env_strings["default_data_volume_size"] ) }"
  data_vol_iops           = "${ coalesce( var.data_vol_iops, var.env_strings["default_data_volume_iops"] ) }"
  data_vol_device_id      = "/dev/sdg"
  data_vol_fs_type        = "ext4"
  data_vol_mount_point    = "/srv/ref/data"
  data_vol_detail_string  = "data:${local.data_vol_type}:${local.data_vol_iops}::${local.data_vol_size}:true:${local.data_vol_device_id}:data:${local.data_vol_fs_type}:${local.data_vol_mount_point}"
}

resource "aws_ebs_volume" "data" {
  count                 = "${var.instance_count}"
  availability_zone     = "${ element( var.vpc_lists["availability_zones"], count.index ) }"
  size                  = "${local.data_vol_size}"
  type                  = "${local.data_vol_type}"
  encrypted             = true
  kms_key_id            = "${aws_kms_key.ebs-volumes.arn}"
  tags                  = "${ merge( var.tags, map( "Name", "${local.org_env_name}-${substr(element(var.vpc_lists["availability_zones"],count.index),-1,1)}${format("%02d",count.index + 1)}-data" ) ) }"
}
locals {
  data_vol_details_ids_list  = "${ formatlist( "${local.data_vol_detail_string}:%s", aws_ebs_volume.data.*.id ) }"
}
resource "aws_volume_attachment" "data" {
  count                 = "${var.instance_count}"
  device_name           = "${local.data_vol_device_id}"
  volume_id             = "${aws_ebs_volume.data.*.id[count.index]}"
  instance_id           = "${module.cluster.instance_ids[count.index]}"
  lifecycle {
    ignore_changes      =  [ "instance_id" ]
  }
}


############################################################
##
##  LOG VOLUME
##

locals {
  log_vol_type           = "${ coalesce( var.log_vol_type, var.env_strings["default_log_volume_type"] ) }"
  log_vol_size           = "${ coalesce( var.log_vol_size, var.env_strings["default_log_volume_size"] ) }"
  log_vol_iops           = "${ coalesce( var.log_vol_iops, var.env_strings["default_log_volume_iops"] ) }"
  log_vol_device_id      = "/dev/sdh"
  log_vol_fs_type        = "ext4"
  log_vol_mount_point    = "/srv/ref/log"
  log_vol_detail_string  = "log:${local.log_vol_type}:${local.log_vol_iops}::${local.log_vol_size}:true:${local.log_vol_device_id}:log:${local.log_vol_fs_type}:${local.log_vol_mount_point}"
}

resource "aws_ebs_volume" "log" {
  count                 = "${var.instance_count}"
  availability_zone     = "${ element( var.vpc_lists["availability_zones"], count.index ) }"
  size                  = "${local.log_vol_size}"
  type                  = "${local.log_vol_type}"
  encrypted             = true
  kms_key_id            = "${aws_kms_key.ebs-volumes.arn}"
  tags                  = "${ merge( var.tags, map( "Name", "${local.org_env_name}-${substr(element(var.vpc_lists["availability_zones"],count.index),-1,1)}${format("%02d",count.index + 1)}-log" ) ) }"
}
locals {
  log_vol_details_ids_list  = "${ formatlist( "${local.log_vol_detail_string}:%s", aws_ebs_volume.log.*.id ) }"
}
resource "aws_volume_attachment" "log" {
  count                 = "${var.instance_count}"
  device_name           = "${local.log_vol_device_id}"
  volume_id             = "${aws_ebs_volume.log.*.id[count.index]}"
  instance_id           = "${module.cluster.instance_ids[count.index]}"
  lifecycle {
    ignore_changes      =  [ "instance_id" ]
  }
}

