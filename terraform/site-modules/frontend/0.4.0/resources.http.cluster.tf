##  FOO INSTANCE CLUSTER CONFIG
variable "http_subnet_group_octet"        { type = "string" }
variable "http_placement_group_strategy"  { type = "string"   default = "" }
variable "http_instance_count"            { type = "string" }
variable "http_instance_ami_id"           { type = "string"   default = "" }
variable "http_instance_type"             { type = "string" }
variable "http_chef_role"                 { type = "string"   default = "" }
variable "http_addl_security_groups"      { type = "list"     default = [] }
locals {
  ##  EVALUATE DEFAULT EC2 INSTANCE PARAMETERS
  http_ami_id        = "${ coalesce( var.http_instance_ami_id, var.base_strings["default_ami_id"] ) }"
  http_instance_type = "${ coalesce( var.http_instance_type, var.env_strings["default_ec2_instance_type"] ) }"
  http_chef_role     = "${ coalesce( var.http_chef_role, "${var.name}" ) }"
}

##  EC2 INSTANCE CLUSTER
module "http_cluster" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//ec2/cluster.private/0.1.11"
  ##  NAME FOR RESOURCES/HOSTNAMES/TAGS/ETC
  name                              = "${var.name}"
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
  subnet_group_octet                = "${var.http_subnet_group_octet}"
  placement_group_strategy          = "${var.http_placement_group_strategy}"
  ##  EC2 INSTANCE CONFIG
  instance_count                    = "${var.http_instance_count}"
  ami_id                            = "${local.http_ami_id}"
  instance_type                     = "${local.http_instance_type}"
  ec2_key                           = "${var.env_strings["ec2_key"]}"
  ##  EC2 SECURITY GROUPS
  ##  ALLOW ACCESS FROM ADMIN SYSTEMS (BASTION, MONITORING, ETC)
  addl_security_groups              = "${concat(
    list( var.vpc_strings["admin-access_sg_id"] ),
    var.http_addl_security_groups
  )}"
  ##  CHEF INTEGRATION
  chef_strings                      = "${var.chef_strings}"
  tf_state_vars                     = "${var.terraform_strings}"
  chef_role                         = "${local.http_chef_role}"
}
output "http_sg_id"                  { value = "${module.http_cluster.sg_id}" }
output "http_internal_cnames"        { value = "${module.http_cluster.internal_cnames_long}" }
output "http_iam_role_arn"           { value = "${module.http_cluster.instance_iam_role_arn}" }
output "http_iam_role_name"          { value = "${module.http_cluster.instance_iam_role_name}" }
output "http_instance_ids"           { value = "${module.http_cluster.instance_ids}" }
output "http_private_ip_addresses"   { value = "${module.http_cluster.instance_private_ip_addresses}" }

##  TARGET GROUP HTTP/80
resource "aws_lb_target_group" "http_80" {
  ##  NAME CANNOT BE LONGER THAN 32 CHARACTERS >:{
  name                              = "${local.env-name}-http-80"
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

resource "aws_lb_target_group_attachment" "http_80" {
  count                             = "${var.http_instance_count}"
  target_group_arn                  = "${aws_lb_target_group.http_80.arn}"
  port                              = 80
  target_id                         = "${module.http_cluster.instance_ids[count.index]}"
  ##  THIS IS REQUIRED DUE TO THE TF11 'ELEMENT' ISSUE
  lifecycle {
    ignore_changes                  = [ "target_id" ]
  }
}

##  ALLOW THE ALB TO ACCESS THE TARGET GROUP ON 80
resource "aws_security_group_rule" "http_cluster_ingress_alb_80" {
  security_group_id                 = "${module.http_cluster.sg_id}"
  description                       = "ALLOW THE ALB TO ACCESS THE TARGET GROUP ON 80"
  type                              = "ingress"
  from_port                         = 80
  to_port                           = 80
  protocol                          = "tcp"
  source_security_group_id          = "${module.alb.sg_id}"
}
