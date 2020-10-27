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
  name        = "${local.org-env-name}_cloudwatch-read-only"
  description = "${local.org-env-name} cloudwatch read-only"
  policy      = "${data.aws_iam_policy_document.cloudwatch-read-only.json}"
}
