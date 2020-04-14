data "aws_ami" "ubuntu_18_04" {
  most_recent = true
  owners      = ["099720109477"] ##  CANONICAL

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

output "ami_ubuntu" {
  value = "${data.aws_ami.ubuntu_18_04.id}"
}
