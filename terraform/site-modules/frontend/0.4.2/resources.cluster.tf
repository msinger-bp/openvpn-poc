##  EC2 INSTANCE CLUSTER
module "cluster" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//ec2/cluster.private/0.1.12"
  ##  NAME FOR RESOURCES/HOSTNAMES/TAGS/ETC
  name                              = "${var.name}"
  ##  EC2 INSTANCES
  instance_count                    = "${var.instance_count}"
  ami_id                            = "${ coalesce( var.ami_id,           var.base_strings["default_ami_id"] ) }"
  instance_type                     = "${ coalesce( var.instance_type,             var.env_strings["default_ec2_instance_type"] ) }"
  ##  ROOT VOLUME
  root_volume_size                  = "${ coalesce( var.root_volume_size, var.env_strings["default_root_volume_size"] ) }"
  root_volume_type                  = "${ coalesce( var.root_volume_type, var.env_strings["default_root_volume_type"] ) }"
  root_volume_iops                  = "${ coalesce( var.root_volume_iops, var.env_strings["default_root_volume_iops"] ) }"
  root_volume_delete_on_termination = "true"
  ##  RESOURCE TAGS
  tags                              = "${var.tags}"
  ##  NETWORK
  subnet_group_octet                = "${var.instance_subnet_group_octet}"
  placement_group_strategy          = "${var.placement_group_strategy}"
  ##  EC2 SECURITY GROUPS
  ##  ALLOW ACCESS FROM ADMIN SYSTEMS (BASTION, MONITORING, ETC)
  addl_security_groups              = "${concat(
    list( var.vpc_strings["admin-access_sg_id"] ),
    var.addl_security_groups
  )}"
  ##  IAM POLICY ARNS - ALL WILL BE ATTACHED TO THE INSTANCE PROFILE / ROLE
  addl_iam_policy_arns              = "${ concat(
    var.chef_lists["iam_policy_arns"],
    var.addl_iam_policy_arns,
    list(aws_iam_policy.ecr.arn)
  ) }"
  addl_iam_policy_count             = "3" ##  MUST BE MANUALLY TALLIED AND AN INTEGER ENTERED HERE
  ##  CHEF INTEGRATION
  chef_strings                      = "${var.chef_strings}"
  tf_state_vars                     = "${var.terraform_strings}"
  chef_role                         = "${ coalesce( var.chef_role, "${var.name}" ) }"
  ##  ENVIRONMENT
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  ec2_key                           = "${var.env_strings["ec2_key"]}"
  ##  VPC
  vpc_id                            = "${var.vpc_strings["id"]}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  az_count                          = "${var.az_count}"
  nat_gw_private_route_table_ids    = "${var.vpc_lists["nat_gw_private_route_table_ids"]}"
  internal_zone_id                  = "${var.vpc_strings["internal_zone_id"]}"
}
output "cluster_sg_id"                  { value = "${module.cluster.sg_id}" }
output "internal_cnames"        { value = "${module.cluster.internal_cnames_long}" }
output "private_ip_addresses"   { value = "${module.cluster.instance_private_ip_addresses}" }
