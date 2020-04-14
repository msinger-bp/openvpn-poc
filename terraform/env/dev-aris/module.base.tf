module "base" {
  source = "../../site-modules/base/0.2.0"

  env_strings       = "${local.env_strings}"
  terraform_strings = "${local.terraform_strings}"
  tags              = "${local.tags}"

  #TF12
  # env = module.env
  # terraform = module.terraform
}

# TODO(TF12): Replace with direct module pass-thru
locals {
  base_strings = {
    default_ami_id        = "${module.base.ami_ubuntu}"
    default_instance_type = "${var.default_instance_type}"       # TODO: output from module
    public_subdomain_id   = "${module.base.public_subdomain_id}"
  }

  base_lists = {
    policy_arns = [
      "${module.base.iam_policy_s3-tfstate-ro}",
      "${module.base.iam_policy_ddb-tfstate-lock-ro_arn}",
    ]
  }
}

#output "env-cloudwatch-log-group_name"      { value = "${module.base.env-cloudwatch-log-group_name}" }
#output "public_subdomain_id"                { value = "${module.base.public_subdomain_id}" }
#output "public_subdomain_name"              { value = "${module.base.public_subdomain_name}" }

