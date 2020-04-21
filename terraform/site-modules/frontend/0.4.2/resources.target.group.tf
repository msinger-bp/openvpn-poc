##  TARGET GROUP
resource "aws_lb_target_group" "default" {
  ##  NAME CANNOT BE LONGER THAN 32 CHARACTERS >:{
  name                              = "${local.org-env-name}"
  port                              = 8080
  protocol                          = "HTTP"
  vpc_id                            = "${var.vpc_strings["id"]}"
  health_check {
    healthy_threshold               = 3
    unhealthy_threshold             = 10
    timeout                         = 5
    interval                        = 10
    path                            = "/api/health"
    port                            = 8080
  }
}

resource "aws_lb_target_group_attachment-8080" "default" {
  count                             = "${var.instance_count}"
  target_group_arn                  = "${aws_lb_target_group.default.arn}"
  port                              = 8080
  target_id                         = "${module.cluster.instance_ids[count.index]}"
  ##  THIS IS REQUIRED DUE TO THE TF11 'ELEMENT' ISSUE
  lifecycle {
    ignore_changes                  = [ "target_id" ]
  }
}

resource "aws_lb_target_group_attachment-8081" "default" {
  count                             = "${var.instance_count}"
  target_group_arn                  = "${aws_lb_target_group.default.arn}"
  port                              = 8081
  target_id                         = "${module.cluster.instance_ids[count.index]}"
  ##  THIS IS REQUIRED DUE TO THE TF11 'ELEMENT' ISSUE
  lifecycle {
    ignore_changes                  = [ "target_id" ]
  }
}

resource "aws_lb_target_group_attachment-8082" "default" {
  count                             = "${var.instance_count}"
  target_group_arn                  = "${aws_lb_target_group.default.arn}"
  port                              = 8082
  target_id                         = "${module.cluster.instance_ids[count.index]}"
  ##  THIS IS REQUIRED DUE TO THE TF11 'ELEMENT' ISSUE
  lifecycle {
    ignore_changes                  = [ "target_id" ]
  }
}

resource "aws_lb_target_group_attachment-8083" "default" {
  count                             = "${var.instance_count}"
  target_group_arn                  = "${aws_lb_target_group.default.arn}"
  port                              = 8083
  target_id                         = "${module.cluster.instance_ids[count.index]}"
  ##  THIS IS REQUIRED DUE TO THE TF11 'ELEMENT' ISSUE
  lifecycle {
    ignore_changes                  = [ "target_id" ]
  }
}

##  ALLOW THE ALB TO ACCESS THE TARGET GROUP ON 80
resource "aws_security_group_rule" "cluster_ingress_alb_80" {
  security_group_id                 = "${module.cluster.sg_id}"
  description                       = "ALLOW THE ALB TO ACCESS THE TARGET GROUP ON 80"
  type                              = "ingress"
  from_port                         = 8080
  to_port                           = 8083
  protocol                          = "tcp"
  source_security_group_id          = "${module.alb.sg_id}"
}
