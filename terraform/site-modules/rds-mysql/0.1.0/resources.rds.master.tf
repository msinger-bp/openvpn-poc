##  MASTER SECURITY GROUP
resource "aws_security_group" "master" {
  name                                  = "${local.org-env-name}-master"
  description                           = "${local.org-env-name}-master"
  vpc_id                                = "${var.vpc_strings["id"]}"
  tags                                  = "${ merge( var.tags, map( "Name", "${local.org-env-name}-master")) }"
}
output "master_sg_id" { value = "${aws_security_group.master.id}" }

resource "aws_db_instance" "master" {

  identifier                            = "${local.org-env-name}-master"

  ##  NETWORK/SECURITY
  db_subnet_group_name                  = "${aws_db_subnet_group.this.name}"
  multi_az                              = "${var.master_multi_az}"
  availability_zone                     = "${ var.master_multi_az == "true" ? "" : ( var.master_az != "" ? var.master_az : element( var.vpc_lists["availability_zones"], 0 ) ) }"
  port                                  = "${var.port}"

  ##  THIS RANDOMLY STOPPED WORKING FOR SOME INEXPLICABLE REASON, POSSIBLY RELATED TO:
  ##    https://github.com/hashicorp/terraform/issues/16856
  ##    https://github.com/hashicorp/terraform/issues/16916
  #vpc_security_group_ids                = "${concat(
    #list( aws_security_group.master.id ),
    #list( var.vpc_strings["admin-access_sg_id"] ),
    #var.addl_security_group_ids
  #)}"
  ##  THIS WORKS NOW, BUT I DON'T KNOW IF IT WILL WORK IF YOU ACTUALLY PUT SOMETHING IN var.addl_security_group_ids
  vpc_security_group_ids              = [
    "${aws_security_group.master.id}",
    "${var.vpc_strings["admin-access_sg_id"]}",
    "${var.addl_security_group_ids}"
  ]

  ##  ENGINE
  engine                                = "mysql"
  engine_version                        = "${ var.engine_minor_version == "" ? var.engine_major_version : "${var.engine_major_version}.${var.engine_minor_version}" }"
  allow_major_version_upgrade           = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade            = "${ var.engine_minor_version == "" ? "true" : "false" }"

  ##  INSTANCE CLASS / TYPE
  instance_class                        = "${ coalesce( var.instance_class, var.env_strings["default_rds_instance_class"] ) }"

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
  skip_final_snapshot                   = "${var.skip_final_snapshot}"
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
output "master_id"        { value = "${aws_db_instance.master.id}" }
output "port"             { value = "${aws_db_instance.master.port}" }
output "admin_username"   { value = "${aws_db_instance.master.username}" }
output "admin_password"   { value = "${aws_db_instance.master.password}" }

##  INTERNAL CNAMES
resource "aws_route53_record" "master_cname_long" {
  zone_id                               = "${var.vpc_strings["internal_zone_id"]}"
  name                                  = "${local.org-env-name}-master"
  type                                  = "CNAME"
  ttl                                   = "300"
  records                               = ["${aws_db_instance.master.address}"]
}
output "master_cname_long"  { value = "${aws_route53_record.master_cname_long.fqdn}" }
output "master_endpoint"  { value = "${aws_route53_record.master_cname_long.fqdn}:${aws_db_instance.master.port}" }
resource "aws_route53_record" "master_cname_short" {
  zone_id                               = "${var.vpc_strings["internal_zone_id"]}"
  name                                  = "${var.name}-master"
  type                                  = "CNAME"
  ttl                                   = "300"
  records                               = ["${aws_db_instance.master.address}"]
}
output "master_cname_short"  { value = "${aws_route53_record.master_cname_short.fqdn}" }
