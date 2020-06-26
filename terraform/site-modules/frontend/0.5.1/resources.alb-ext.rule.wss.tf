##  SINGLE-INSTANCE TARGET GROUP FOR SECURE WEBSOCKETS
resource "aws_lb_target_group" "alb-ext-wss" {
  ##  NAME CANNOT BE LONGER THAN 32 CHARACTERS >:{
  name                              = "${local.env-name}-alb-ext-wss"
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
##  ATTACH ONE/FIRST INSTANCE TO THE WSS TARGET GROUP
resource "aws_lb_target_group_attachment" "alb-ext-wss-8080" {
  target_group_arn                  = "${aws_lb_target_group.alb-ext-wss.arn}"
  port                              = 8080
  target_id                         = "${module.cluster.instance_ids[0]}"
  ##  THIS IS REQUIRED DUE TO THE TF11 'ELEMENT' ISSUE
  lifecycle {
    ignore_changes                  = [ "target_id" ]
  }
}
##  EXTERNAL ALB, PORT 443 LISTENER RULE FOR /socket.io/*
resource "aws_lb_listener_rule" "alb-ext-wss" {
  listener_arn = "${aws_lb_listener.ext_443.arn}"
  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.alb-ext-wss.arn}"
  }
  condition {
    path_pattern {
      values = ["/socket.io/*"]
    }
  }
}
