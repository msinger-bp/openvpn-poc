resource "aws_elasticache_replication_group" "this" {
  count                         = "${var.count}"
  replication_group_id          = "${local.org-env-name}-${local.az_abbr}${format("%02d",count.index + 1)}" ## MAX 40 CHARS
  replication_group_description = "${local.org-env-name}-${local.az_abbr}${format("%02d",count.index + 1)}"
  subnet_group_name             = "${var.subnet_group_name}"
  number_cache_clusters         = "2"
  availability_zones            = [ "${var.target_az}", "${var.secondary_az}" ]
  automatic_failover_enabled    = "true"
  security_group_ids            = [ "${var.sg_ids}" ]
  node_type                     = "${var.node_type}"
  engine_version                = "${var.engine_version}"
  port                          = "${var.port}"
  parameter_group_name          = "${var.parameter_group_name}"
  at_rest_encryption_enabled    = "${var.at_rest_encryption_enabled}"
  kms_key_id                    = "${var.kms_key_id}"
  transit_encryption_enabled    = "${var.transit_encryption_enabled}"
  snapshot_window               = "${var.snapshot_window}"
  snapshot_retention_limit      = "${var.snapshot_retention_limit}"
  maintenance_window            = "${var.maintenance_window}"
  notification_topic_arn        = "${var.notification_topic_arn}"
  tags                          = "${ merge( var.tags, map( "Name", "${local.org-env-name}-${local.az_abbr}${format("%02d",count.index + 1)}" ) ) }"
  lifecycle {
    ##  REQUIRED TO PREVENT PERPETUAL PLAN DIFFERENCES
    ##  https://www.terraform.io/docs/providers/aws/r/elasticache_replication_group.html
    ignore_changes              = ["number_cache_clusters"]
  }
}
output "endpoints"  { value = "${aws_elasticache_replication_group.this.*.primary_endpoint_address}" }
