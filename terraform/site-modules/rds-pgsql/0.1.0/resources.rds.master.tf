##  MASTER SECURITY GROUP
resource "aws_security_group" "master" {
  name                                  = "${local.org-env-name}-master"
  description                           = "${local.org-env-name}-master"
  vpc_id                                = "${var.vpc_strings["id"]}"
  tags                                  = "${ merge( var.tags, map( "Name", "${local.org-env-name}-master")) }"
}
output "master_sg_id" { value           = "${aws_security_group.master.id}" }

resource "aws_db_instance" "master" {

  identifier                            = "${local.org-env-name}-master"

  ##  NETWORK/SECURITY
  db_subnet_group_name                  = "${aws_db_subnet_group.this.name}"
  multi_az                              = "${var.master_multi_az}"
  ##  IF YOU ARE USING THE RDS "MULTI-AZ" FEATURE, THEN YOU DON'T GET TO SPECIFY THE AZ
  availability_zone                     = "${ var.master_multi_az == "true" ? "" : ( var.master_az != "" ? var.master_az : element( var.vpc_lists["availability_zones"], 0 ) ) }"
  port                                  = "${var.port}"
  vpc_security_group_ids                = ["${aws_security_group.master.id}"]

  ##  ENGINE
  engine                                = "postgres"
  engine_version                        = "${var.engine_version}"
  allow_major_version_upgrade           = "${var.allow_major_version_upgrade}"

  ##  INSTANCE CLASS / TYPE
  instance_class                        = "${var.instance_class}"

  ##  STORAGE
  allocated_storage                     = "${ coalesce( var.allocated_storage, "10" ) }"
  max_allocated_storage                 = "${ coalesce( var.max_allocated_storage, var.allocated_storage, "10" ) }"
  storage_type                          = "${var.storage_type}"
  iops                                  = "${var.iops}"
  storage_encrypted                     = "true"
  kms_key_id                            = "${aws_kms_key.this.arn}"

  ##  SOURCE SNAPSHOT
  snapshot_identifier                   = "${var.source_snapshot_identifier}"

  ##  DATABASE
  name                                  = "${var.database_name}"
  username                              = "${var.admin_username}"
  password                              = "${local.effective_admin_password}"
  iam_database_authentication_enabled   = "${var.iam_database_authentication_enabled}"

  ##  PARAMETER GROUP
  parameter_group_name                  = "${aws_db_parameter_group.this.name}"

  ##  OPTION GROUP
  #option_group_name                    = "${aws_db_option_group.this.name}"    ##  SEE resources.option.group.tf

  ##  BACKUPS
  backup_retention_period               = "${var.backup_retention_period}"
  backup_window                         = "${var.backup_window}"
  copy_tags_to_snapshot                 = "true"
  skip_final_snapshot                   = "${var.skip_final_snapshot}"  ## NOTE: THIS IS IGNORED, https://github.com/terraform-providers/terraform-provider-aws/issues/2588
  final_snapshot_identifier             = "${local.org-env-name}-Final"
  deletion_protection                   = "${var.deletion_protection}"

  ##  MAINTENANCE
  maintenance_window                    = "${var.maintenance_window}"
  apply_immediately                     = "${var.apply_immediately}"

  ##  MONITORING
  monitoring_interval                   = "${var.monitoring_interval}"
  monitoring_role_arn                   = "${coalesce(var.monitoring_role_arn, join("", aws_iam_role.enhanced_monitoring.*.arn))}"
  enabled_cloudwatch_logs_exports       = "${var.enabled_cloudwatch_logs_exports}"

  ##  TAGS
  tags                                  = "${ merge( var.tags, map( "Name", "${local.org-env-name}-master")) }"

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

##  INTERNAL CNAME
resource "aws_route53_record" "master_cname" {
  zone_id                               = "${var.vpc_strings["internal_zone_id"]}"
  name                                  = "${local.org-env-name}-master"
  type                                  = "CNAME"
  ttl                                   = "300"
  records                               = ["${aws_db_instance.master.address}"]
}

##  OUTPUTS
output "master_id"        { value = "${aws_db_instance.master.id}" }
output "master_endpoint"  { value = "${aws_route53_record.master_cname.fqdn}:${aws_db_instance.master.port}" }
output "admin_username"   { value = "${aws_db_instance.master.username}" }
output "admin_password"   { value = "${aws_db_instance.master.password}" }
