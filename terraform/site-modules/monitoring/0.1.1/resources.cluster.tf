##  EC2 INSTANCE CLUSTER
module "cluster" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//ec2/cluster.private/0.1.13"
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
  subnet_group_octet                = "${var.subnet_group_octet}"
  ##  EC2 INSTANCE CONFIG
  instance_count                    = "${var.instance_count}"
  ami_id                            = "${local.ami_id}"
  instance_type                     = "${var.instance_type}"
  ec2_key                           = "${var.env_strings["ec2_key"]}"
  ##  EBS VOLUMES FROM resources.ebs.vols.tf
  ebs_vol_config_string_list        = "${data.template_file.all_ebs_volume_detail_id_lists.*.rendered}"
  ebs_vol_config_string_count       = "${local.ebs_vol_config_string_count}"
  ##  EC2 SECURITY GROUPS
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
  chef_role                         = "${local.chef_role}"
}
output "instance_sg_id"                 { value = "${module.cluster.sg_id}" }
output "internal_cnames"                { value = "${module.cluster.internal_cnames_long}" }
output "instance_ids"                   { value = "${module.cluster.instance_ids}" }
output "instance_private_ip_addresses"  { value = "${module.cluster.instance_private_ip_addresses}" }
