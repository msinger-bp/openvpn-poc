resource "aws_security_group" "rds-backup" {
  name                                  = "${local.org-env-name}-rds-backup"
  description                           = "${local.org-env-name}-rds-backup"
  vpc_id                                = "${var.vpc_strings["id"]}"
  tags                                  = "${ merge( var.tags, map( "Name", "${local.org-env-name}-rds-backup")) }"
}
output "rds-backup_sg_id" { value = "${aws_security_group.rds-backup.id}" }
