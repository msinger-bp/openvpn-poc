module "vpc" {
  source                = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//vpc-net/vpc/0.1.1"
  name                  = "${var.name}"
  org                   = "${var.env_strings["org"]}"
  env                   = "${var.env_strings["env"]}"
  cidr_16               = "${var.cidr_16}"
  az_list               = "${var.az_list}"
  az_count              = "${var.az_count}"
  internal_zone_name    = "${var.internal_zone_name}"
  tags                  = "${var.tags}"
}
output "cidr_block"                     { value = "${module.vpc.cidr_block}" }
output "cidr_16"                        { value = "${module.vpc.cidr_16}" }
output "default_route_table_id"         { value = "${module.vpc.default_route_table_id}" }
output "endpoint_dynamodb_id"           { value = "${module.vpc.endpoint_dynamodb_id}" }
output "endpoint_dynamodb_pl_id"        { value = "${module.vpc.endpoint_dynamodb_pl_id}" }
output "endpoint_s3_id"                 { value = "${module.vpc.endpoint_s3_id}" }
output "endpoint_s3_pl_id"              { value = "${module.vpc.endpoint_s3_pl_id}" }
output "id"                             { value = "${module.vpc.id}" }
output "igw_id"                         { value = "${module.vpc.igw_id}" }
output "internal_zone_name"             { value = "${module.vpc.internal_zone_name}" }
output "internal_zone_id"               { value = "${module.vpc.internal_zone_id}" }
output "nat_gw_eips"                    { value = ["${module.vpc.nat_gw_eips}"] }
output "nat_gw_private_route_table_ids" { value = ["${module.vpc.nat_gw_private_route_table_ids}"] }
output "public_igw_route_table_id"      { value = "${module.vpc.public_igw_route_table_id}" }
