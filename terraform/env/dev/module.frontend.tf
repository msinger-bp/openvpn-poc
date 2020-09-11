##  FRONTEND

module "frontend" {
  source                      = "../../site-modules/frontend/0.5.4"
  name                        = "frontend"
  ##  ALB
  alb-ext_subnet_group_octet  = "${var.subnet_group_octets["frontend_alb-ext"]}"
  alb-int_subnet_group_octet  = "${var.subnet_group_octets["frontend_alb-int"]}"
  ##  INSTANCE CLUSTER
  instance_subnet_group_octet = "${var.subnet_group_octets["frontend_instances"]}"
  placement_group_strategy    = "spread"
  instance_count              = "1"
  instance_type               = "t3.medium"
  chef_role                   = "frontend_http"
  ##  ELASTICACHE / REDIS
  redis_subnet_group_octet    = "${var.subnet_group_octets["frontend_redis"]}"
  ##  OUTPUTS FROM REQUIRED MODULES
  env_strings                 = "${local.env_strings}"
  base_strings                = "${local.base_strings}"
  vpc_strings                 = "${local.vpc-main_strings}"
  vpc_lists                   = "${local.vpc-main_lists}"
  az_count                    = "${var.vpc-main_az_count}"
  chef_strings                = "${local.chef_strings}"
  chef_lists                  = "${local.chef_lists}"
  chef_iam_policy_count       = "${module.chef.iam_policy_count}"
  terraform_strings           = "${local.terraform_strings}"
  tags                        = "${local.tags}"
  ecr_arn                     = "arn:aws:ecr:us-west-2:695990525005:repository/frontend"
  db-main_sg                  = "${module.maindb.master_sg_id}"
  bastion_sg                  = "${module.bastion.sg_id}"
}

output "frontend_alb-ext_public_cname"  { value = "${module.frontend.alb-ext_public_cname}" }
output "frontend_internal_cnames"       { value = "${module.frontend.internal_cnames}" }
output "frontend_alb-int_public_cname"  { value = "${module.frontend.alb-int_public_cname}" }
output "frontend_socketio_redis"        { value = "${module.frontend.redis_dns_name}" }
