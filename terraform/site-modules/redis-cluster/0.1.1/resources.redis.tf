module "redis" {

  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//db/elasticache/redis.cluster/0.1.1"

  name                              = "${var.name}"
  replication_group_id              = "${var.replication_group_id}"

  subnet_group_octet                = "${var.subnet_group_octet}"

  ##  NODE CONFIG
  port                             = "${var.port}"
  node_type                        = "${ coalesce( var.node_type, var.env_strings["default_redis_node_type"] ) }"
  engine_version                   = "${var.engine_version}"
  at_rest_encryption_enabled       = "${var.at_rest_encryption_enabled}"

  ##  CLUSTER CONFIG
  num_node_groups                   = "${var.num_node_groups}"
  replicas_per_node_group           = "${var.replicas_per_node_group}"
  automatic_failover_enabled        = "${var.automatic_failover_enabled}"

  ## ENVIRONMENT
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  tags                              = "${var.tags}"

  ##  VPC
  vpc_id                            = "${var.vpc_strings["id"]}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  az_count                          = "${var.az_count}"
  nat_gw_private_route_table_ids    = "${var.vpc_lists["nat_gw_private_route_table_ids"]}"

  ##  INTERNAL DNS
  internal_zone_id                  = "${var.vpc_strings["internal_zone_id"]}"

}
output "sg_id"                          { value = "${module.redis.sg_id}" }
output "id"                             { value = "${module.redis.id}" }
output "member_clusters"                { value = "${module.redis.member_clusters}" }
output "configuration_endpoint_address" { value = "${module.redis.configuration_endpoint_address}" }
output "internal_cname"                 { value = "${module.redis.internal_cname}" }
