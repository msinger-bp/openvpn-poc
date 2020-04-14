resource "aws_eip" "nlb" {
  count                             = "${var.az_count}"
  vpc                               = "true"
}
output "eip_list" { value = "${aws_eip.nlb.*.public_ip}" }
