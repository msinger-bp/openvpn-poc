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
  ##  IF YOU ARE USING THE RDS "MULTI-AZ" FEATURE, THEN YOU DON'T GET TO SPECIFY THE AZ
  availability_zone                     = "${ var.replica_multi_az == "true" ? "" : ( var.replica_az != "" ? var.replica_az : element(var.vpc_lists["availability_zones"], count.index) ) }"
  multi_az                              = "${var.replica_multi_az}"
  port                                  = "${var.port}"
  vpc_security_group_ids                = ["${aws_security_group.replica.id}"]

  ##  ENGINE
  engine                                = "${aws_db_instance.master.engine}"
  engine_version                        = "${var.engine_version}"
  allow_major_version_upgrade           = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade            = "${var.auto_minor_version_upgrade}"

  ##  INSTANCE CLASS / TYPE
  instance_class                        = "${var.instance_class}"

  ##  STORAGE - TYPE AND IOPS ARE AUTOMATICALLY COPIED FROM THE MASTER CONFIG
  allocated_storage                     = "${ coalesce( var.allocated_storage, "10" ) }"
  max_allocated_storage                 = "${ coalesce( var.max_allocated_storage, var.allocated_storage, "10" ) }"
  storage_encrypted                     = "true"
  kms_key_id                            = "${aws_kms_key.this.arn}"

  ##  DATABASE / REPLICATION / SOURCE / CREDENTIALS
  replicate_source_db                   = "${aws_db_instance.master.id}" ##  REPLICATION SOURCE (MASTER)
  #iam_database_authentication_enabled   = "${var.iam_database_authentication_enabled}" ##  TEST - SEE IF THIS GETS COPIED FROM MASTER

  ##  PARAMETER GROUP
  parameter_group_name                  = "${aws_db_parameter_group.this.name}"

  ##  OPTION GROUP
  #option_group_name                    = "${aws_db_option_group.this.name}"    ##  SEE resources.option.group.tf

  ##  BACKUPS
  skip_final_snapshot                   = "${var.skip_final_snapshot}"
  ##  MAINTENANCE
  maintenance_window                    = "${var.maintenance_window}"
  apply_immediately                     = "${var.apply_immediately}"

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
resource "aws_route53_record" "replica_cnames" {
  count                                 = "${var.replica_count}"
  zone_id                               = "${var.vpc_strings["internal_zone_id"]}"
  name                                  = "${local.org-env-name}-replica-${count.index + 1}"
  type                                  = "CNAME"
  ttl                                   = "300"
  records                               = [ "${ element( aws_db_instance.replica.*.address, count.index ) }" ]
}

##  OUTPUTS
output "replica_ids"        { value = "${aws_db_instance.replica.*.id}" }
output "replica_endpoints"  { value = "${aws_route53_record.replica_cnames.*.fqdn}" }
