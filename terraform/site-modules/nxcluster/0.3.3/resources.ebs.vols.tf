##  CUSTOMER-MANAGED KMS KEY, IF REQUIRED
resource "aws_kms_key" "ebs-volumes" {
  description       = "${local.org-env-name}"
  tags              = "${local.tags_w_name}"
}

module "az_0_volumes" {
  source            = "./ebs-vols"
  name              = "${var.name}"
  instance_count    = "${var.az_0_instance_count}"
  instance_ids      = "${module.cluster.az_0_instance_ids}"
  kms_key_arn       = "${aws_kms_key.ebs-volumes.arn}"
  az                = "${element(var.vpc_lists["availability_zones"],0)}"
  env_strings       = "${local.env_strings}"
  org               = "${var.env_strings["org"]}"
  env               = "${var.env_strings["env"]}"
  tags              = "${var.tags}"
}
module "az_1_volumes" {
  source            = "./ebs-vols"
  name              = "${var.name}"
  instance_count    = "${var.az_1_instance_count}"
  instance_ids      = "${module.cluster.az_1_instance_ids}"
  kms_key_arn       = "${aws_kms_key.ebs-volumes.arn}"
  az                = "${element(var.vpc_lists["availability_zones"],1)}"
  env_strings       = "${local.env_strings}"
  org               = "${var.env_strings["org"]}"
  env               = "${var.env_strings["env"]}"
  tags              = "${var.tags}"
}
module "az_2_volumes" {
  source            = "./ebs-vols"
  name              = "${var.name}"
  instance_count    = "${var.az_2_instance_count}"
  instance_ids      = "${module.cluster.az_2_instance_ids}"
  kms_key_arn       = "${aws_kms_key.ebs-volumes.arn}"
  az                = "${element(var.vpc_lists["availability_zones"],2)}"
  env_strings       = "${local.env_strings}"
  org               = "${var.env_strings["org"]}"
  env               = "${var.env_strings["env"]}"
  tags              = "${var.tags}"
}
