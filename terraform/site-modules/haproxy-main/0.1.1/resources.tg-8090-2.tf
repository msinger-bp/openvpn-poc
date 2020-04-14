##  TARGET GROUP
##  TO CREATE A SEPARATE STREAM, COPY THIS FILE AND CHANGE "tg-8090-2" TO "tg-123"
##  AND ADD THE APPROPRIATE HAPROXY CONFIG IN 'site-cookbooks/haproxy-main'

##  TARGET GROUP
resource "aws_lb_target_group" "tg-8090-2" {
  name                      = "${local.env-name}-8090-2"  ##  MAX 32 CHARS
  vpc_id                    = "${var.vpc_strings["id"]}"
  port                      = "8090"
  protocol                  = "TCP"
  health_check {
    protocol                = "TCP"
    healthy_threshold       = "${ lookup( var.tg-8090-2, "health_check_threshold", local.default_tg_health_check_threshold ) }"
    unhealthy_threshold     = "${ lookup( var.tg-8090-2, "health_check_threshold", local.default_tg_health_check_threshold ) }"
    interval                = "${ lookup( var.tg-8090-2, "health_check_interval",  local.default_tg_health_check_interval ) }"
  }
  ##  STICKINESS IS ENABLED BY DEFAULT AND NOT SUPPORTED FOR NLBS, SO WE HAVE TO SET IT TO NULL VALUE
  ##  https://github.com/terraform-providers/terraforhaproxy_name_tag_mapm-provider-aws/issues/2746
  stickiness                = []
  tags                      = "${ merge( var.tags, map( "Name", "${local.org-env-name}-tg-8090-2" ) ) }"
}
output "tg-8090-2_arn" { value = "${aws_lb_target_group.tg-8090-2.arn}" }
resource "aws_lb_target_group_attachment" "tg-8090-2_az0" {
  count                     = "${var.instance_count_az0}"
  target_group_arn          = "${aws_lb_target_group.tg-8090-2.arn}"
  port                      = "8090"
  target_id                 = "${module.haproxy.az_0_instance_ids[count.index]}"
  ##  THIS IS REQUIRED DUE TO THE TF11 'ELEMENT' ISSUE
  lifecycle {
    ignore_changes          = [ "target_id" ]
  }
}
resource "aws_lb_target_group_attachment" "tg-8090-2_az1" {
  count                     = "${var.instance_count_az1}"
  target_group_arn          = "${aws_lb_target_group.tg-8090-2.arn}"
  port                      = "8090"
  target_id                 = "${module.haproxy.az_1_instance_ids[count.index]}"
  lifecycle {
    ignore_changes          = [ "target_id" ]
  }
}
resource "aws_lb_target_group_attachment" "tg-8090-2_az2" {
  count                     = "${var.instance_count_az2}"
  target_group_arn          = "${aws_lb_target_group.tg-8090-2.arn}"
  port                      = "8090"
  target_id                 = "${module.haproxy.az_2_instance_ids[count.index]}"
  lifecycle {
    ignore_changes          = [ "target_id" ]
  }
}


##  ALLOW EVERYWHERE TO ACCESS HAPROXY INSTANCES ON 8090
##  NOTE: WITH NLBS, YOU SET THE SG RULES ON THE TARGETS, NOT THE LB ITSELF
#resource "aws_security_group_rule" "everywhere_to_haproxy_tg-8090-2" {
  #security_group_id         = "${module.haproxy.sg_id}"
  #description               = "ALLOW EVERYWHERE TO ACCESS HAPROXY ON 8090"
  #type                      = "ingress"
  #from_port                 = "8090"
  #to_port                   = "8090"
  #protocol                  = "tcp"
  #cidr_blocks               = [ "0.0.0.0/0" ]
#}

#locals {
  #tg-8090-2_url_list      = "${ formatlist( "http://%s:%s", aws_route53_record.nlb_cname.fqdn, aws_lb_listener.tg-8090-2.*.port ) }"
#}
#output "tg-8090-2_url_list"     { value = "${local.tg-8090-2_url_list}" }

###  ALLOW HAPROXY TO ACCESS STREAM1 BACKEND
#resource "aws_security_group_rule" "haproxy_to_tg-8090-2_backend" {
  #security_group_id         = "${var.tg-8090-2["backend_sg_id"]}"
  #description               = "ALLOW HAPROXY TO ACCESS BACKEND"
  #type                      = "ingress"
  #from_port                 = "8090"
  #to_port                   = "8090"
  #protocol                  = "tcp"
  #source_security_group_id  = "${module.haproxy.sg_id}"
#}
