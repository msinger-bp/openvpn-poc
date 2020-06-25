module "lambda" {
  source              = "../../site-modules/lambda/0.1.0"
  name                = "lambda"
  subnet_group_octet  = "${var.subnet_group_octets["lambda"]}"
  env_strings         = "${local.env_strings}"
  base_strings        = "${local.base_strings}"
  vpc_strings         = "${local.vpc-main_strings}"
  vpc_lists           = "${local.vpc-main_lists}"
  az_count            = "${var.vpc-main_az_count}"
  tags                = "${local.tags}"
}
