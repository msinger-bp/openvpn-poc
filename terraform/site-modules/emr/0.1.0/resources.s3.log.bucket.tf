resource "aws_s3_bucket" "log" {
  bucket          = "${local.org-env-name}-log"
  acl             = "private"
  tags            = "${ merge( var.tags, map( "Name", "${local.org-env-name}-log" ) ) }"
  force_destroy   = "true"
}
locals {
  log_bucket_uri  = "s3://${aws_s3_bucket.log.id}/EMR/"
}
output "log_bucket_name"    { value = "${aws_s3_bucket.log.id}" }
output "log_bucket_uri"     { value = "${local.log_bucket_uri}" }
