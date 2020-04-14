data "aws_iam_policy_document" "cloudwatch-read-only" {
  statement {
    actions   = [
        "autoscaling:Describe*",
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "logs:Get*",
        "logs:Describe*",
        "sns:Get*",
        "sns:List*"
    ]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "cloudwatch-read-only" {
  description = "${local.org-env} cloudwatch read-only"
  name        = "${local.org-env}_cloudwatch-read-only"
  #path       = "/some/sort/of/path/for/a/policy" # TO DO: INVESTIGATE THIS
  policy      = "${data.aws_iam_policy_document.cloudwatch-read-only.json}"
}
output "iam-policy_cloudwatch-read-only_id"   { value = "${aws_iam_policy.cloudwatch-read-only.id}" }
output "iam-policy_cloudwatch-read-only_arn"  { value = "${aws_iam_policy.cloudwatch-read-only.arn}" }
output "iam-policy_cloudwatch-read-only_name" { value = "${aws_iam_policy.cloudwatch-read-only.name}" }
output "iam-policy_cloudwatch-read-only_path" { value = "${aws_iam_policy.cloudwatch-read-only.path}" }
