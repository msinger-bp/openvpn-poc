resource "random_id" "rds-backup_random_admin_password" {
  byte_length = 10
}
locals {
  rds-backup_effective_admin_password = "${var.rds-backup_admin_password == "" ? random_id.rds-backup_random_admin_password.b64 : var.rds-backup_admin_password}"
}
