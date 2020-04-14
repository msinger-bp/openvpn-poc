data "aws_ami" "aws_ecs" {
  owners      = ["amazon"]
  most_recent = "true"

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "ami_aws_ecs_id" {
  value = "${data.aws_ami.aws_ecs.id}"
}
