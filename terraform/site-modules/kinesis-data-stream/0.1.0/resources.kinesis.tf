resource "aws_kinesis_stream" "this" {
  name                = "${local.org-env-name}"
  shard_count         = "${var.shard_count}"
  retention_period    = "${var.retention_period}"

  encryption_type     = "KMS"
  kms_key_id          = "${aws_kms_key.this.arn}"

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
    "OutgoingRecords",
    "ReadProvisionedThroughputExceeded",
    "WriteProvisionedThroughputExceeded",
    "IncomingRecords",
    "IteratorAgeMilliseconds",
  ]

  tags                = "${local.tags_w_name}"
  #tags {
    #ForwardToFirehoseStream = "${var.create_s3_backup ? join("",aws_kinesis_firehose_delivery_stream.this.*.name) : ""}"
  #}
}
output "arn" { value = "${aws_kinesis_stream.this.arn}" }
