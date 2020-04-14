resource "aws_cloudwatch_log_group" "env-cloudwatch-log-group" {
  name = "${local.org-env}"
  tags = "${local.tags_w_name}"
}

output "env-cloudwatch-log-group_arn" {
  value = "${aws_cloudwatch_log_group.env-cloudwatch-log-group.arn}"
}

output "env-cloudwatch-log-group_name" {
  value = "${aws_cloudwatch_log_group.env-cloudwatch-log-group.name}"
}
