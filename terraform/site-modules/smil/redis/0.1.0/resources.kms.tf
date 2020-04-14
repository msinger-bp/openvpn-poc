resource "aws_kms_key" "redis" {
  description = "${local.org-env-name}"
  tags        = "${local.tags_w_name}"
}
