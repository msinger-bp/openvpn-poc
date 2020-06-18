##  TARGET GROUP
resource "aws_lb_target_group" "alb-ext" {
  ##  NAME CANNOT BE LONGER THAN 32 CHARACTERS >:{
  name                              = "${local.org-env-name}-alb-ext"
  port                              = 8080
  protocol                          = "HTTP"
  vpc_id                            = "${var.vpc_strings["id"]}"
  health_check {
    healthy_threshold               = 3
    unhealthy_threshold             = 10
    timeout                         = 5
    interval                        = 10
    path                            = "/api/health"
  }
}

resource "aws_lb_target_group_attachment" "alb-ext-8080" {
  count                             = "${var.instance_count}"
  target_group_arn                  = "${aws_lb_target_group.alb-ext.arn}"
  port                              = 8080
  target_id                         = "${module.cluster.instance_ids[count.index]}"
  ##  THIS IS REQUIRED DUE TO THE TF11 'ELEMENT' ISSUE
  lifecycle {
    ignore_changes                  = [ "target_id" ]
  }
}

resource "aws_lb_target_group_attachment" "alb-ext-8081" {
  count                             = "${var.instance_count}"
  target_group_arn                  = "${aws_lb_target_group.alb-ext.arn}"
  port                              = 8081
  target_id                         = "${module.cluster.instance_ids[count.index]}"
  ##  THIS IS REQUIRED DUE TO THE TF11 'ELEMENT' ISSUE
  lifecycle {
    ignore_changes                  = [ "target_id" ]
  }
}

resource "aws_lb_target_group_attachment" "alb-ext-8082" {
  count                             = "${var.instance_count}"
  target_group_arn                  = "${aws_lb_target_group.alb-ext.arn}"
  port                              = 8082
  target_id                         = "${module.cluster.instance_ids[count.index]}"
  ##  THIS IS REQUIRED DUE TO THE TF11 'ELEMENT' ISSUE
  lifecycle {
    ignore_changes                  = [ "target_id" ]
  }
}

resource "aws_lb_target_group_attachment" "alb-ext-8083" {
  count                             = "${var.instance_count}"
  target_group_arn                  = "${aws_lb_target_group.alb-ext.arn}"
  port                              = 8083
  target_id                         = "${module.cluster.instance_ids[count.index]}"
  ##  THIS IS REQUIRED DUE TO THE TF11 'ELEMENT' ISSUE
  lifecycle {
    ignore_changes                  = [ "target_id" ]
  }
}
