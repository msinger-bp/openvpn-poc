module "redis" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//db/elasticache/redis/0.1.2"
  name                              = "${var.name}-redis"
  subnet_group_octet                = "${var.redis_subnet_group_octet}"
  node_type                         = "${var.redis_node_type}"
  engine_version                    = "${var.redis_engine_version}"
  number_cache_clusters             = 2
  snapshot_window                   = "${var.redis_snapshot_window}"
  snapshot_retention_limit          = "${var.redis_snapshot_retention_limit}"
  maintenance_window                = "${var.redis_maintenance_window}"
  org                               = "${var.env_strings["org"]}"
  env                               = "${var.env_strings["env"]}"
  tags                              = "${var.tags}"
  vpc_id                            = "${var.vpc_strings["id"]}"
  vpc_cidr_16                       = "${var.vpc_strings["cidr_16"]}"
  az_list                           = "${var.vpc_lists["availability_zones"]}"
  az_count                          = "${var.az_count}"
  nat_gw_private_route_table_ids    = "${var.vpc_lists["nat_gw_private_route_table_ids"]}"
  internal_zone_id                  = "${var.vpc_strings["internal_zone_id"]}"
}
output "redis_sg_id"                { value = "${module.redis.sg_id}" }
output "redis_primary_endpoint"     { value = "${module.redis.primary_endpoint_address}" }
output "redis_reader_endpoint"      { value = "${module.redis.reader_endpoint_address}" }
