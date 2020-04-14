resource "random_id" "random_admin_password" {
  byte_length = 10
}
locals {
  effective_admin_password = "${var.admin_password == "" ? random_id.random_admin_password.b64 : var.admin_password}"
}
