locals {

  ##  HANDY NAMES WITH HYPHENS
  env-name      = "${var.env_strings["env"]}-${var.name}"
  org-env-name  = "${var.env_strings["org-env"]}-${var.name}"
  ##  HANDY NAMES WITH UNDERSCORES
  env_name      = "${var.env_strings["env"]}_${var.name}"
  org_env_name  = "${var.env_strings["org_env"]}_${var.name}"

  ##  EVALUATE DEFAULT EC2 INSTANCE PARAMETERS
  ami_id        = "${ coalesce( var.ami_id, var.base_strings["default_ami_id"] ) }"
  instance_type = "${ coalesce( var.instance_type, var.env_strings["default_ec2_instance_type"] ) }"
  chef_role     = "${ coalesce( var.chef_role, var.name ) }"

  ##  HANDY TAG MAP WITH ADDITIONAL SIMPLE NAME TAG "org-env-name"
  tags_w_name   = "${ merge( var.tags, map( "Name", "${local.org-env-name}" ) ) }"

}
