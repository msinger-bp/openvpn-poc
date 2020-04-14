module "redis" {
  source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//db/elasticache/redis/0.1.1"
  name                              = "${var.name}"
  subnet_group_octet                = "${var.subnet_group_octet}"
  ##  REDIS CONFIG
  #port                             = "" # DEFAULT 6379
  #node_type                        = "" # DEFAULT cache.t2.small
  #engine_version                   = "" # DEFAULT 3.2.6; CHANGES TO ENGINE VERSION AFTER CREATION WILL NOT TAKE EFFECT
  #automatic_failover_enabled       = "" # DEFAULT true
  ##  AT-REST ENCRYPTION
  ##  ONLY AWS-MANAGED KMS KEYS ARE SUPPORTED, NOT CUSTOMER-MANAGED KEYS (CMK)
  ##  SUPPORTED engine_version: 3.2.6, 4.0.10+ (NOT 3.2.10)
  ##  SUPPORTED node_type: M5, M4, T2, R5, R4
  ##  CAN ONLY BE ENABLED WHEN YOU CREATE A REDIS REPLICATION GROUP - CANNOT BE ENABLED ON EXISTING REPLICATION GROUPS
  ##  DEFAULT true
  #at_rest_encryption_enabled       = "false"
  ##  ELASTICACHE-REDIS NATIVE CLUSTERING
  ##  WHEN SPECIFYING PREFERRED AVAILABILITY ZONES, THE NUMBER OF CACHE CLUSTERS MUST BE SPECIFIED AND MUST MATCH THE NUMBER OF PREFERRED AVAILABILITY ZONES
  #number_cache_clusters            = "" # DEFAULTS TO # OF AZS IN VPC
  #availability_zones               = "" # DEFAULT TO ALL THE AZS IN VPC
  #availability_zones               = [ "${element(var.az_list,0)}","${element(var.az_list,1)}" ] ##  IF YOU ARE NOT USING THE DEFAULT, YOU MUST SPECIFY A LIST OF AZ(S)
  #number_cache_clusters            = 2
  availability_zones                = "${var.vpc_lists["availability_zones"]}"
  number_cache_clusters             = "${var.az_count}"
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
output "sg_id"                        { value = "${module.redis.sg_id}" }
output "primary_endpoint_address"  { value = "${module.redis.primary_endpoint_address}" }

