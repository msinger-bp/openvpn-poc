##  FOO INSTANCE CLUSTER CONFIG
variable "https_subnet_group_octet"        { type = "string" }
variable "https_placement_group_strategy"  { type = "string"   default = "" }
variable "https_instance_count"            { type = "string" }
variable "https_instance_ami_id"           { type = "string"   default = "" }
variable "https_instance_type"             { type = "string" }
variable "https_chef_role"                 { type = "string"   default = "" }
variable "https_addl_security_groups"      { type = "list"     default = [] }
locals {
  ##  EVALUATE DEFAULT EC2 INSTANCE PARAMETERS
  https_ami_id        = "${ coalesce( var.https_instance_ami_id, var.base_strings["default_ami_id"] ) }"
  https_instance_type = "${ coalesce( var.https_instance_type, var.env_strings["default_ec2_instance_type"] ) }"
  https_chef_role     = "${ coalesce( var.https_chef_role, "${var.name}_https" ) }"
}

##  EC2 INSTANCE CLUSTER
module "https_cluster" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//ec2/cluster.private/0.1.11"
  ##  NAME FOR RESOURCES/HOSTNAMES/TAGS/ETC
  name                              = "${var.name}-https"
  ##  ENVIRONMENT
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  ##  RESOURCE TAGS
  tags                              = "${var.tags}"
  ##  VPC
  vpc_id                            = "${var.vpc_strings["id"]}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  az_count                          = "${var.az_count}"
  nat_gw_private_route_table_ids    = "${var.vpc_lists["nat_gw_private_route_table_ids"]}"
  internal_zone_id                  = "${var.vpc_strings["internal_zone_id"]}"
  ##  NETWORK CONFIG
  subnet_group_octet                = "${var.https_subnet_group_octet}"
  placement_group_strategy          = "${var.https_placement_group_strategy}"
  ##  EC2 INSTANCE CONFIG
  instance_count                    = "${var.https_instance_count}"
  ami_id                            = "${local.https_ami_id}"
  instance_type                     = "${local.https_instance_type}"
  ec2_key                           = "${var.env_strings["ec2_key"]}"
  ##  EC2 SECURITY GROUPS
  ##  ALLOW ACCESS FROM ADMIN SYSTEMS (BASTION, MONITORING, ETC)
  addl_security_groups              = "${concat(
    list( var.vpc_strings["admin-access_sg_id"] ),
    var.https_addl_security_groups
  )}"
  ##  CHEF INTEGRATION
  chef_strings                      = "${var.chef_strings}"
  tf_state_vars                     = "${var.terraform_strings}"
  chef_role                         = "${local.https_chef_role}"
}
output "https_sg_id"                  { value = "${module.https_cluster.sg_id}" }
output "https_internal_cnames"        { value = "${module.https_cluster.internal_cnames_long}" }
output "https_iam_role_arn"           { value = "${module.https_cluster.instance_iam_role_arn}" }
output "https_iam_role_name"          { value = "${module.https_cluster.instance_iam_role_name}" }
output "https_instance_ids"           { value = "${module.https_cluster.instance_ids}" }
output "https_private_ip_addresses"   { value = "${module.https_cluster.instance_private_ip_addresses}" }

##  TARGET GROUP HTTP/80
resource "aws_lb_target_group" "https_80" {
  ##  NAME CANNOT BE LONGER THAN 32 CHARACTERS >:{
  name                              = "${local.env-name}-https-80"
  port                              = 80
  protocol                          = "HTTP"
  vpc_id                            = "${var.vpc_strings["id"]}"
  health_check {
    healthy_threshold               = 3
    unhealthy_threshold             = 10
    timeout                         = 5
    interval                        = 10
    path                            = "/index.html"
    port                            = 80
  }
}

resource "aws_lb_target_group_attachment" "https_80" {
  count                             = "${var.https_instance_count}"
  target_group_arn                  = "${aws_lb_target_group.https_80.arn}"
  port                              = 80
  target_id                         = "${module.https_cluster.instance_ids[count.index]}"
  ##  THIS IS REQUIRED DUE TO THE TF11 'ELEMENT' ISSUE
  lifecycle {
    ignore_changes                  = [ "target_id" ]
  }
}

##  ALLOW THE ALB TO ACCESS THE TARGET GROUP ON 80
resource "aws_security_group_rule" "https_cluster_ingress_alb_80" {
  security_group_id                 = "${module.https_cluster.sg_id}"
  description                       = "ALLOW THE ALB TO ACCESS THE TARGET GROUP ON 80"
  type                              = "ingress"
  from_port                         = 80
  to_port                           = 80
  protocol                          = "tcp"
  source_security_group_id          = "${module.alb.sg_id}"
}
