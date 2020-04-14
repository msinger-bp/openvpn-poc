#
#data "template_file" "ops_sensei_instance_user_data" {
#  template                  = "${file("${path.module}/user.data.sensei.instances.tpl")}"
#  vars {
#    SERVER_PORT             = "${var.ops_sensei_listen_port}"
#  }
#}
#
#resource "aws_launch_configuration" "ops_sensei_instances" {
#  image_id                  = "${var.ami_id}"
#  instance_type             = "${var.ops_sensei_instance_type}"
#  security_groups           = ["${local.ops_sensei_sg_id}"]
#  key_name                  = "${var.ec2_key}"
#  user_data                 = "${data.template_file.ops_sensei_instance_user_data.rendered}"
#  lifecycle {
#    create_before_destroy   = true
#    ignore_changes          = [
#      "image_id",
#      "volume_tags",
#      "user_data",
#      "instance_type",
#      "root_block_device.0.volume_size",
#    ]
#  }
#}
#
#locals {
#  sensei_name_tag = {
#    name                    = "${var.name}-sensei"
#  }
#  ops_sensei_tag_map    = "${ merge( local.tags, local.sensei_name_tag ) }"
#}
#
#data "null_data_source" "ops_sensei_asg_tag_list" {
#  count                     = "${ length(  keys(   local.ops_sensei_tag_map ) ) }"
#  inputs = {
#    key                     = "${ element( keys(   local.ops_sensei_tag_map), count.index)}"
#    value                   = "${ element( values( local.ops_sensei_tag_map), count.index)}"
#    propagate_at_launch     = "true"
#  }
#}
#
#resource "aws_autoscaling_group" "ops_sensei" {
#  name                      = "ops_sensei"
#  launch_configuration      = "${aws_launch_configuration.ops_sensei_instances.id}"
#  vpc_zone_identifier       = ["${local.ops_sensei_subnet_ids}"]
#  min_size                  = 3
#  max_size                  = 3
#  tags                      = ["${data.null_data_source.ops_sensei_asg_tag_list.*.outputs}"]
#}
#
#resource "aws_lb_target_group" "ops_sensei" {
#  name                      = "ops-sensei"
#  port                      = 80
#  protocol                  = "HTTP"
#  vpc_id                    = "${var.vpc_id}"
#  stickiness {
#    type                    = "lb_cookie"
#    cookie_duration         = 1800
#    enabled                 = false
#  }
#  health_check {
#    healthy_threshold       = 3
#    unhealthy_threshold     = 10
#    timeout                 = 5
#    interval                = 10
#    path                    = "/sensei"
#    port                    = "${var.ops_sensei_listen_port}"
#  }
#}
#
#resource "aws_alb_listener_rule" "ops_alb_http_80_sensei" {
#  depends_on                = ["aws_lb_target_group.ops_sensei"]
#  listener_arn              = "${aws_lb_listener.ops_alb_http_80.arn}"
#  action {
#    type                    = "forward"
#    target_group_arn        = "${aws_lb_target_group.ops_sensei.id}"
#  }
#  condition {
#    field                   = "path-pattern"
#    values                  = ["/sensei*"]
#  }
#}
#
#resource "aws_autoscaling_attachment" "ops_sensei_asg_alb_attach" {
#  alb_target_group_arn      = "${aws_lb_target_group.ops_sensei.arn}"
#  autoscaling_group_name    = "${aws_autoscaling_group.ops_sensei.id}"
#}
#
