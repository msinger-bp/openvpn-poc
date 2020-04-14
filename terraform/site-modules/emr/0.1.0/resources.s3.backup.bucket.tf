##  BUCKET FOR BACKUP/TRANSFER OF EMR DATA
resource "aws_s3_bucket" "emr-transfer" {
  bucket          = "${local.org-env-name}-emr-transfer"
  acl             = "private"
  lifecycle_rule {
    id            = "delete_after_90_days"
    enabled       = true
    expiration {
      days        = 90
    }
  }
  tags            = "${ merge( var.tags, map( "Name", "${local.org-env-name}-emr-transfer" ) ) }"
  #force_destroy   = "true" ##  FOR WHEN YOU REALLY NEED IT
}
locals {
  emr-transfer_bucket_uri  = "s3://${aws_s3_bucket.emr-transfer.id}"
}
output "emr-transfer_bucket_name"    { value = "${aws_s3_bucket.emr-transfer.id}" }
output "emr-transfer_bucket_uri"     { value = "${local.emr-transfer_bucket_uri}" }

##  BUCKET POLICY TO RESTRICT ACCESS TO THE VPC
resource "aws_s3_bucket_policy" "emr-transfer" {
  bucket = "${aws_s3_bucket.emr-transfer.id}"
  policy = <<POLICY
{
  "Version":                "2012-10-17",
  "Id":                     "${local.org-env-name}-emr-transfer",
  "Statement": [
    {
      "Sid":                "${local.org-env-name}-emr-transfer",
      "Effect":             "Allow",
      "Principal":          "*",
      "Action":             "s3:*",
      "Resource":           "arn:aws:s3:::${local.org-env-name}-emr-transfer",
      "Condition": {
        "StringEquals": {
          "aws:SourceVpc":  "${var.vpc_strings["id"]}"
        }
      }
    }
  ]
}
POLICY
}
      #"Action": [
         #"s3:Put*",
         #"s3:List*"
      #],
