##  SECURITY GROUP FOR ALL EC2 INSTANCES IN THE VPC
##  FOR BASTION SSH ACCESS, MONITORING, ETC
resource "aws_security_group" "admin-access" {
  name        = "${var.env_strings["org-env"]}-admin-access"
  description = "Allows administrative access such as SSH from bastions, monitoring, etc"
  vpc_id      = "${module.vpc.id}"
  tags        = "${ merge( var.tags, map( "Name", "${var.env_strings["org-env"]}-admin-access" ) ) }"

  ##  POSSIBLY PREVENTS SG MODIFICATION FROM CAUSING A BROKEN DEPENDENCY
  ##  https://github.com/hashicorp/terraform/issues/8617
  lifecycle {
    create_before_destroy = true
  }
}

output "admin-access_sg_id" { value = "${aws_security_group.admin-access.id}" }
