module "cluster" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//ec2/cluster.public/0.1.9"
  name                              = "${var.name}"
  subnet_group_octet                = "${var.subnet_group_octet}"
  instance_count                    = "${ coalesce( var.instance_count,                     var.az_count ) }"
  ami_id                            = "${ coalesce( var.ami_id,                             var.base_strings["default_ami_id"] ) }"
  instance_type                     = "${ coalesce( var.instance_type,                      var.env_strings["default_ec2_instance_type"] ) }"
  root_volume_size                  = "${ coalesce( var.root_volume_size,                   var.env_strings["default_root_volume_size"]                   ) }"
  root_volume_type                  = "${ coalesce( var.root_volume_type,                   var.env_strings["default_root_volume_type"]                   ) }"
  root_volume_iops                  = "${ coalesce( var.root_volume_iops,                   var.env_strings["default_root_volume_iops"]                   ) }"
  root_volume_delete_on_termination = "${ coalesce( var.root_volume_delete_on_termination,  var.env_strings["default_root_volume_delete_on_termination"]  ) }"
  addl_iam_policy_arns              = "${ concat( var.chef_lists["iam_policy_arns"], var.addl_iam_policy_arns ) }"
  ## PITA, BUT WITH TF11, YOU HAVE TO MANUALLY COUNT LISTS
  #addl_iam_policy_count            = "${var.chef_iam_policy_count}" ##  IF YOU ARE ONLY USING THE CHEF IAM POLICIES
  addl_iam_policy_count             = "2"                             ##  OTHERWISE, YOU HAVE TO COUNT THEM UP AND PUT A NUMERAL HERE
  addl_security_groups              = [ "${var.vpc_strings["admin-access_sg_id"]}" ]  ##  BASTIONS ARE IN THE ADMIN SG
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  ec2_key                           = "${var.env_strings["ec2_key"]}"
  tags                              = "${var.tags}"
  vpc_id                            = "${var.vpc_strings["id"]}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  az_count                          = "${var.az_count}"
  public_igw_route_table_id         = "${var.vpc_strings["public_igw_route_table_id"]}"
  internal_zone_id                  = "${var.vpc_strings["internal_zone_id"]}"
  public_subdomain_id               = "${var.base_strings["public_subdomain_id"]}"
  chef_role                         = "${ coalesce( var.chef_role, var.name ) }"
  chef_strings                      = "${var.chef_strings}"
  tf_state_vars                     = "${var.terraform_strings}"
}
output "sg_id"            { value = "${module.cluster.sg_id}" }
output "public_cnames"    { value = "${module.cluster.public_cnames}" }
output "internal_cnames"  { value = "${module.cluster.internal_cnames_long}" }
