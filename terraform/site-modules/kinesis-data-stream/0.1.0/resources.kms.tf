##  CREATES A CUSTOMER-MANAGED KMS KEY (CMK)
resource "aws_kms_key" "this" {
  description   = "${local.org-env-name}"
  tags          = "${local.tags_w_name}"
}
