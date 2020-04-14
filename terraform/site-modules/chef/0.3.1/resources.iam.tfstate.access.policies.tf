##  IAM POLICY TO ALLOW READ ACCESS TO THE TFSTATE DDB LOCK TABLE
data "aws_dynamodb_table" "tfstate-lock" {
  name = "${var.terraform_strings["tfstate_ddb_lock_table"]}"
}
data "aws_iam_policy_document" "ddb-tfstate-lock-ro" {
  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:Query",
      "dynamodb:GetItem",
      "dynamodb:Scan",
    ]
    resources = [
      "${data.aws_dynamodb_table.tfstate-lock.arn}",
    ]
  }
}
resource "aws_iam_policy" "ddb-tfstate-lock-ro" {
  name   = "${var.env_strings["org_env"]}_ddb-tfstate-lock-ro"
  path   = "/"
  policy = "${data.aws_iam_policy_document.ddb-tfstate-lock-ro.json}"
}
output "iam_policy_ddb-tfstate-lock-ro_arn" { value = "${aws_iam_policy.ddb-tfstate-lock-ro.arn}" }

##  IAM POLICY TO ALLOW READ ACCESS TO THE TFSTATE FILE IN S3
data "aws_iam_policy_document" "s3-tfstate-ro" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.terraform_strings["tfstate_s3_bucket"]}"]
  }
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.terraform_strings["tfstate_s3_bucket"]}/${var.terraform_strings["tfstate_key"]}"]
  }
}
resource "aws_iam_policy" "s3-tfstate-ro" {
  name   = "${var.env_strings["org_env"]}_s3-tfstate-ro"
  path   = "/"
  policy = "${data.aws_iam_policy_document.s3-tfstate-ro.json}"
}
output "iam_policy_s3-tfstate-ro" { value = "${aws_iam_policy.s3-tfstate-ro.arn}" }

output "iam_policy_count" { value = "2" }
