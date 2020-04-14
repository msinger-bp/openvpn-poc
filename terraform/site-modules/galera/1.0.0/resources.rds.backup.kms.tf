resource "aws_kms_key" "rds-backup" {
  description = "${local.org-env-name}-rds-backup"
  tags        = "${ merge( var.tags, map( "Name", "${local.org-env-name}-rds-backup")) }"
}
