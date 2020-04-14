##  "graphite-access" SECURITY GROUP
##  ALLOW ACCESS THE PROMETHEUS SYSTEMS ON 9109 (TCP & UDP) TO PUSH DATA TO GRAPHITE
resource "aws_security_group" "graphite-access" {
  name                      = "${var.env_strings["org-env"]}-graphite-access"
  description               = "${var.env_strings["org-env"]}} graphite access"
  vpc_id                    = "${var.vpc_strings["id"]}"
  tags                      = "${ merge( var.tags, map( "Name", "${var.env_strings["org-env"]}-graphite-access" ) ) }"
}
output "graphite-access_sg_id" { value = "${aws_security_group.graphite-access.id}" }
resource "aws_security_group_rule" "prometheus_graphite-access_9109_tcp" {
  security_group_id         = "${module.cluster.sg_id}"
  description               = "allow prometheus access to members of the graphite-access sg on 9109"
  type                      = "ingress"
  from_port                 = 9109
  to_port                   = 9109
  protocol                  = "tcp"
  source_security_group_id  = "${aws_security_group.graphite-access.id}" 
}
resource "aws_security_group_rule" "prometheus_graphite-access_9109_udp" {
  security_group_id         = "${module.cluster.sg_id}"
  description               = "allow prometheus access to members of the graphite-access sg on 9109"
  type                      = "ingress"
  from_port                 = 9109
  to_port                   = 9109
  protocol                  = "udp"
  source_security_group_id  = "${aws_security_group.graphite-access.id}" 
}
