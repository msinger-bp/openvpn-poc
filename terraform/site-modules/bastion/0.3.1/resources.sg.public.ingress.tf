##  ALLOW SSH ACCESS FROM EVERYWHERE TO THE BASTIONS
##  TODO: THIS COULD BE RESTRICTED TO KNOWN NETWORKS AND/OR JUMP HOSTS
resource "aws_security_group_rule" "bastion_ssh_from_everywhere" {
  security_group_id = "${module.cluster.sg_id}"
  description       = "allow ssh access from everywhere to the bastions"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
