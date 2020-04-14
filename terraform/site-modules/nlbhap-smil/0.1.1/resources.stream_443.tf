##  NLB->HAPROXY TRAFFIC STREAM #1
##  TO CREATE A SEPARATE STREAM, COPY THIS FILE AND CHANGE "stream-443" TO "stream-xyz"
##  AND ADD THE APPROPRIATE HAPROXY CONFIG IN 'site-cookbooks/smil-net-main'
##  NOTE: EACH STREAM MUST HAVE A SEPARATE NLB PORT

##  TARGET GROUP
resource "aws_lb_target_group" "stream-443" {
  name                      = "${local.org-env-name}"  ##  MAX 32 CHARS
  vpc_id                    = "${var.vpc_strings["id"]}"
  port                      = "443"
  protocol                  = "TCP"
  health_check {
    ##  Health check healthy threshold and unhealthy threshold must be the same for target groups with the TCP protocol
    protocol                = "TCP"
    healthy_threshold       = "${ lookup( var.stream-443, "tg_health_check_threshold", "3"   ) }"
    unhealthy_threshold     = "${ lookup( var.stream-443, "tg_health_check_threshold", "3"   ) }"
    interval                = "${ lookup( var.stream-443, "tg_health_check_interval",  "10"  ) }"
  }
  ##  STICKINESS IS ENABLED BY DEFAULT AND NOT SUPPORTED FOR NLBS, SO WE HAVE TO SET IT TO NULL VALUE
  ##  https://github.com/terraform-providers/terraforhaproxy_name_tag_mapm-provider-aws/issues/2746
  stickiness                = []
  tags                      = "${ merge( var.tags, map( "Name", "${local.org-env-name}-stream-443" ) ) }"
}
resource "aws_lb_target_group_attachment" "stream-443_az0" {
  count                     = "${var.instance_count_az0}"
  target_group_arn          = "${aws_lb_target_group.stream-443.arn}"
  port                      = "443"
  target_id                 = "${module.haproxy.az_0_instance_ids[count.index]}"
  ##  THIS IS REQUIRED DUE TO THE TF11 'ELEMENT' ISSUE
  lifecycle {
    ignore_changes          = [ "target_id" ]
  }
}
resource "aws_lb_target_group_attachment" "stream-443_az1" {
  count                     = "${var.instance_count_az1}"
  target_group_arn          = "${aws_lb_target_group.stream-443.arn}"
  port                      = "443"
  target_id                 = "${module.haproxy.az_1_instance_ids[count.index]}"
  lifecycle {
    ignore_changes          = [ "target_id" ]
  }
}
resource "aws_lb_target_group_attachment" "stream-443_az2" {
  count                     = "${var.instance_count_az2}"
  target_group_arn          = "${aws_lb_target_group.stream-443.arn}"
  port                      = "443"
  target_id                 = "${module.haproxy.az_2_instance_ids[count.index]}"
  lifecycle {
    ignore_changes          = [ "target_id" ]
  }
}
resource "aws_lb_listener" "stream-443" {
  load_balancer_arn         = "${aws_lb.nlb.arn}"
  port                      = "443"
  protocol                  = "TCP"
  default_action {
    type                    = "forward"
    target_group_arn        = "${aws_lb_target_group.stream-443.arn}"
  }
}
##  ALLOW EVERYWHERE TO ACCESS HAPROXY INSTANCES ON 443
##  NOTE: WITH NLBS, YOU SET THE SG RULES ON THE TARGETS, NOT THE LB ITSELF
resource "aws_security_group_rule" "everywhere_to_haproxy_stream-443" {
  security_group_id         = "${module.haproxy.sg_id}"
  description               = "ALLOW EVERYWHERE TO ACCESS HAPROXY ON 443"
  type                      = "ingress"
  from_port                 = "443"
  to_port                   = "443"
  protocol                  = "tcp"
  cidr_blocks               = [ "0.0.0.0/0" ]
}

#locals {
  #stream-443_url_list      = "${ formatlist( "http://%s:%s", aws_route53_record.nlb_cname.fqdn, aws_lb_listener.stream-443.*.port ) }"
#}
#output "stream-443_url_list"     { value = "${local.stream-443_url_list}" }

###  ALLOW HAPROXY TO ACCESS STREAM1 BACKEND
#resource "aws_security_group_rule" "haproxy_to_stream-443_backend" {
  #security_group_id         = "${var.stream-443["backend_sg_id"]}"
  #description               = "ALLOW HAPROXY TO ACCESS BACKEND"
  #type                      = "ingress"
  #from_port                 = "443"
  #to_port                   = "443"
  #protocol                  = "tcp"
  #source_security_group_id  = "${module.haproxy.sg_id}"
#}
