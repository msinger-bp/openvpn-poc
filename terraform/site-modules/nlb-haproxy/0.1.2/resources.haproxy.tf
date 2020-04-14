###########################################################
##
##  HAPROXY RESOURCES
##
module "haproxy" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//ec2/cluster.private/0.1.11"
  name                              = "${var.name}-haproxy"
  subnet_group_octet                = "${var.haproxy_subnet_group_octet}"
  instance_count                    = "${ coalesce( var.instance_count, var.az_count ) }" ##  DEFAULT TO ONE PER AZ
  ami_id                            = "${ coalesce( var.ami_id, var.base_strings["default_ami_id"] ) }"
  instance_type                     = "${ coalesce( var.instance_type, var.env_strings["default_ec2_instance_type"] ) }"
  addl_security_groups              = [ "${ concat( var.addl_security_groups, list(var.vpc_strings["admin-access_sg_id"]) ) }" ]
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  ec2_key                           = "${var.env_strings["ec2_key"]}"
  #addl_iam_policy_arns              = "${var.addl_iam_policy_arns}"
  addl_iam_policy_arns              = "${ concat( var.chef_lists["iam_policy_arns"], var.addl_iam_policy_arns ) }"
  addl_iam_policy_count             = "${var.chef_iam_policy_count + length( var.addl_iam_policy_arns ) }"
  vpc_id                            = "${var.vpc_strings["id"]}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  az_count                          = "${var.az_count}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  internal_zone_id                  = "${var.vpc_strings["internal_zone_id"]}"
  nat_gw_private_route_table_ids    = "${var.vpc_lists["nat_gw_private_route_table_ids"]}"
  tags                              = "${var.tags}"
  ##  CHEF INTEGRATION
  chef_role                         = "${ coalesce( var.chef_role, "${var.name}-haproxy" ) }"
  chef_strings                      = "${var.chef_strings}"
  tf_state_vars                     = "${var.terraform_strings}"
}
output "instance_ids"                   { value = "${module.haproxy.instance_ids}" }
output "instance_private_ip_addresses"  { value = "${module.haproxy.instance_private_ip_addresses}" }
output "internal_cnames"                { value = "${module.haproxy.internal_cnames_long}" }
output "sg_id"                          { value = "${module.haproxy.sg_id}" }
