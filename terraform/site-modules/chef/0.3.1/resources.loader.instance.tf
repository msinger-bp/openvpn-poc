data "template_file" "cloud-init-user-data" {
  template                      = "${file("${path.module}/mount.chef.efs.user.data.tpl")}"
  vars {
    CHEF_EFS_MOUNT_DIR          = "${var.efs_mount_dir}"
    CHEF_EFS_VOL_MOUNT_TARGET   = "${module.efs-vol.mount_target_dns_names[0]}"
  }
}

module "loader-instance" {
  source                        = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//ec2/cluster.public.stoppable/0.1.0"
  name                          = "${var.name}-loader-instance"
  count                         = "1"
  subnet_group_octet            = "${var.loader-instance_subnet_group_octet}"
  ami_id                        = "${local.ami_id}"
  instance_type                 = "${local.instance_type}"
  extra_userdata                = "${data.template_file.cloud-init-user-data.rendered}"
  org                           = "${var.env_strings["org"]}"
  env                           = "${var.env_strings["env"]}"
  ec2_key                       = "${var.env_strings["ec2_key"]}"
  tags                          = "${var.tags}"
  vpc_id                        = "${var.vpc_strings["id"]}"
  vpc_cidr_16                   = "${var.vpc_strings["cidr_16"]}"
  az_list                       = "${var.vpc_lists["availability_zones"]}"
  az_count                      = "${var.az_count}"
  public_igw_route_table_id     = "${var.vpc_strings["public_igw_route_table_id"]}"
  internal_zone_id              = "${var.vpc_strings["internal_zone_id"]}"
  public_subdomain_id           = "${var.base_strings["public_subdomain_id"]}"
}

output "loader-instance_sg_id" { value = "${module.loader-instance.sg_id}" }

resource "aws_security_group_rule" "loader_ssh_from_everywhere" {
  description                   = "${local.org-env-name} loader instance"
  security_group_id             = "${module.loader-instance.sg_id}"
  type                          = "ingress"
  from_port                     = 22
  to_port                       = 22
  protocol                      = "tcp"
  cidr_blocks                   = ["0.0.0.0/0"]
}
