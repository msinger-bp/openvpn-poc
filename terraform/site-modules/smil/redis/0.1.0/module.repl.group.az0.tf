module "repl-group-az0" {
  source                        = "./repl.groups.per.az"
  name                          = "${var.name}"
  subnet_group_name             = "${aws_elasticache_subnet_group.this.name}"
  count                         = "${var.repl_group_count_az0}"
  target_az                     = "${element(var.vpc_lists["availability_zones"],0)}"
  secondary_az                  = "${element(var.vpc_lists["availability_zones"],1)}"
  sg_ids                        = [ "${aws_security_group.this.id}", "${var.vpc_strings["admin-access_sg_id"]}" ]
  node_type                     = "${coalesce(var.node_type,var.env_strings["default_redis_node_type"])}"
  engine_version                = "${var.engine_version}"
  port                          = "${var.port}"
  parameter_group_name          = "${aws_elasticache_parameter_group.this.name}"
  at_rest_encryption_enabled    = "${var.at_rest_encryption_enabled}"
  kms_key_id                    = "${aws_kms_key.redis.arn}"
  transit_encryption_enabled    = "${var.transit_encryption_enabled}"
  snapshot_window               = "${var.snapshot_window}"
  snapshot_retention_limit      = "${var.snapshot_retention_limit}"
  maintenance_window            = "${var.maintenance_window}"
  notification_topic_arn        = "${var.notification_topic_arn}"
  tags                          = "${var.tags}"
  vpc_strings                   = "${var.vpc_strings}"
  env_strings                   = "${var.env_strings}"
}
output "endpoint_cnames_long_az0"  { value = "${module.repl-group-az0.endpoint_cnames_long}" }
output "endpoint_cnames_short_az0"  { value = "${module.repl-group-az0.endpoint_cnames_short}" }
