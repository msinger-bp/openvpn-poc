##  REPLICA SECURITY GROUP
resource "aws_security_group" "replica" {
  name                                  = "${local.org-env-name}-replica"
  description                           = "${local.org-env-name}-replica"
  vpc_id                                = "${var.vpc_strings["id"]}"
  tags                                  = "${ merge( var.tags, map( "Name", "${local.org-env-name}-replica" ) ) }"
}
output "replica_sg_id" { value = "${aws_security_group.replica.id}" }

resource "aws_db_instance" "replica" {

  count                                 = "${var.replica_count}"

  identifier                            = "${local.org-env-name}-replica-${count.index + 1}"  ##  REPLICA NAMES ARE ONE-ORDERED

  ##  NETWORKING / SECURITY
  availability_zone                     = "${ var.replica_multi_az == "true" ? "" : ( var.replica_az != "" ? var.replica_az : element(var.vpc_lists["availability_zones"], count.index) ) }"
  multi_az                              = "${var.replica_multi_az}"
  port                                  = "${var.port}"
  vpc_security_group_ids                = ["${aws_security_group.replica.id}", "${var.vpc_strings["admin-access_sg_id"]}" ]

  ##  ENGINE
  engine                                = "${aws_db_instance.master.engine}"
  engine_version                        = "${ var.engine_minor_version == "" ? var.engine_major_version : "${var.engine_major_version}.${var.engine_minor_version}" }"
  allow_major_version_upgrade           = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade            = "${ var.engine_minor_version == "" ? "true" : "false" }"

  ##  INSTANCE CLASS / TYPE
  instance_class                        = "${ coalesce( var.instance_class, var.env_strings["default_rds_instance_class"] ) }"

  ##  STORAGE - TYPE AND IOPS ARE AUTOMATICALLY COPIED FROM THE MASTER CONFIG
  allocated_storage                     = "${ coalesce( var.allocated_storage, "10" ) }"
  max_allocated_storage                 = "${ coalesce( var.max_allocated_storage, var.allocated_storage, "10" ) }"
  storage_encrypted                     = "true"
  ##  WHEN USING "snapshot_identifier" TO SEED THE CLUSTER WITH A PRE-EXISTING SNAPSHOT, THE REPLICAS PRODUCE THIS ERROR:
  ##  "InvalidParameterCombination: Your request does not require the KMS key parameter. Please remove the KMS key parameter and try your request again."
  ##  EXCLUDING THE 'kms_key_id' PARAMETER FIXES THE ERROR
  kms_key_id                            = "${aws_kms_key.this.arn}"

  ##  DATABASE / REPLICATION / SOURCE / CREDENTIALS
  replicate_source_db                   = "${aws_db_instance.master.id}"
  iam_database_authentication_enabled   = "${var.iam_database_authentication_enabled}"

  ##  PARAMETER GROUP
  parameter_group_name                  = "${aws_db_parameter_group.this.name}"

  ##  OPTION GROUP
  #option_group_name                    = "${aws_db_option_group.this.name}"    ##  SEE resources.option.group.tf

  ##  MAINTENANCE
  maintenance_window                    = "${var.maintenance_window}"
  apply_immediately                     = "${var.apply_immediately}"

  ##  BACKUPS
  skip_final_snapshot                   = "${var.skip_final_snapshot}"

  ##  MONITORING
  monitoring_interval                   = "${var.monitoring_interval}"
  monitoring_role_arn                   = "${coalesce(var.monitoring_role_arn, join("", aws_iam_role.enhanced_monitoring.*.arn))}"
  enabled_cloudwatch_logs_exports       = "${var.enabled_cloudwatch_logs_exports}"

  ##  TAGS
  tags                                  = "${ merge( var.tags, map( "Name", "${local.org_env_name}-replica-${count.index + 1}-${element(var.vpc_lists["availability_zones"],count.index)}")) }"

  ##  TF MGMT
  lifecycle {
    ignore_changes                      = [
      ##  https://github.com/terraform-providers/terraform-provider-aws/issues/6075
      "name",
      "id",
      ##  PREVENTS RE-CREATION IF ENGINE IS UPGRADED
      "engine_version",
      ##  PREVENTS RE-CREATION IF "snapshot_identifier" PARAMETER IS DELETED OR CHANGED
      "snapshot_identifier"
    ]
  }
  timeouts                              = "${var.timeouts}"

}

##  REPLICA INTERNAL CNAMES
resource "aws_route53_record" "replica_cnames_long" {
  count                                 = "${var.replica_count}"
  zone_id                               = "${var.vpc_strings["internal_zone_id"]}"
  name                                  = "${local.org-env-name}-replica-${count.index + 1}"
  type                                  = "CNAME"
  ttl                                   = "300"
  records                               = [ "${ element( aws_db_instance.replica.*.address, count.index ) }" ]
}
resource "aws_route53_record" "replica_cnames_short" {
  count                                 = "${var.replica_count}"
  zone_id                               = "${var.vpc_strings["internal_zone_id"]}"
  name                                  = "${var.name}-replica-${count.index + 1}"
  type                                  = "CNAME"
  ttl                                   = "300"
  records                               = [ "${ element( aws_db_instance.replica.*.address, count.index ) }" ]
}
resource "aws_route53_record" "replica_cnames_short_w_az" {
  count                                 = "${var.replica_count}"
  zone_id                               = "${var.vpc_strings["internal_zone_id"]}"
  name                                  = "${var.name}-replica-${count.index + 1}-${element(var.vpc_lists["availability_zones"], count.index)}"
  type                                  = "CNAME"
  ttl                                   = "300"
  records                               = [ "${ element( aws_db_instance.replica.*.address, count.index ) }" ]
}

##  OUTPUTS
output "replica_ids"        { value = "${aws_db_instance.replica.*.id}" }
output "replica_endpoints"  { value = "${formatlist( "%s:%s", aws_route53_record.replica_cnames_long.*.fqdn, aws_db_instance.master.port ) }" }
