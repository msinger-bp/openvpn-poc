##  NLB->HAPROXY->BACKEND TRAFFIC STREAM #1
##  TO CREATE A SEPARATE STREAM, COPY THIS FILE AND CHANGE "nlb2stream2" TO "stream2"
##  AND ADD THE APPROPRIATE HAPROXY CONFIG IN 'site-cookbooks/nlbhap'
##  NOTE: EACH STREAM MUST HAVE A SEPARATE NLB PORT
resource "aws_lb_target_group" "nlb2stream2" {
  name                  = "${local.org-env-name}-nlb2stream2"  ##  MAX 32 CHARS
  vpc_id                = "${var.vpc_strings["id"]}"
  port                  = "${ lookup( var.nlb2stream2, "haproxy_port", "80" ) }"
  protocol              = "TCP"
  health_check {
    ##  Health check healthy threshold and unhealthy threshold must be the same for target groups with the TCP protocol
    protocol            = "TCP"
    healthy_threshold   = "${ lookup( var.nlb2stream2, "tg_healthy_threshold",    "3"   ) }"
    unhealthy_threshold = "${ lookup( var.nlb2stream2, "tg_unhealthy_threshold",  "3"   ) }"
    interval            = "${ lookup( var.nlb2stream2, "tg_interval",             "10"  ) }"
  }
  ##  STICKINESS IS ENABLED BY DEFAULT AND NOT SUPPORTED FOR NLBS, SO WE HAVE TO SET IT TO NULL VALUE
  ##  https://github.com/terraform-providers/terraforhaproxy_name_tag_mapm-provider-aws/issues/2746
  stickiness            = []
  tags                  = "${ merge( var.tags, map( "Name", "${local.org-env-name}-nlb2stream2" ) ) }"
}
output "nlb2stream2_haproxy_port" { value = "${aws_lb_target_group.nlb2stream2.port}" }
resource "aws_lb_target_group_attachment" "nlb2stream2" {
  count                 = "${ coalesce( var.instance_count, var.az_count ) }"
  target_group_arn      = "${aws_lb_target_group.nlb2stream2.arn}"
  port                  = "${ lookup( var.nlb2stream2, "haproxy_port", "80" ) }"
  target_id             = "${module.haproxy.instance_ids[count.index]}"
  ##  THIS IS REQUIRED DUE TO THE TF11 'ELEMENT' ISSUE
  lifecycle {
    ignore_changes      = [ "target_id" ]
  }
}
resource "aws_lb_listener" "nlb2stream2" {
  count                 = "${ length( var.nlb2stream2_nlb_ports ) }"
  load_balancer_arn     = "${aws_lb.nlb2.arn}"
  port                  = "${ element( var.nlb2stream2_nlb_ports, count.index ) }"
  protocol              = "TCP"
  default_action {
    type                = "forward"
    target_group_arn    = "${aws_lb_target_group.nlb2stream2.arn}"
  }
}
output "nlb2stream2_nlb_ports" { value = [ "${aws_lb_listener.nlb2stream2.*.port}" ] }
##  ALLOW EVERYWHERE TO ACCESS HAPROXY INSTANCES ON THE STREAM1 PORT
##  NOTE: WITH NLBS, YOU SET THE SG RULES ON THE TARGETS, NOT THE LB ITSELF
resource "aws_security_group_rule" "everywhere_to_haproxy_nlb2stream2_port" {
  security_group_id     = "${module.haproxy.sg_id}"
  description           = "ALLOW EVERYWHERE TO ACCESS HAPROXY ON STREAM1 PORT"
  type                  = "ingress"
  from_port             = "${ lookup( var.nlb2stream2, "haproxy_port", "80" ) }"
  to_port               = "${ lookup( var.nlb2stream2, "haproxy_port", "80" ) }"
  protocol              = "tcp"
  cidr_blocks           = [ "0.0.0.0/0" ]
}

##  ALLOW HAPROXY TO ACCESS STREAM1 BACKEND
##  NOTE: UNNECESSARY FOR NLB2 STREAM1 BECAUSE NLB1 STREAM2 TAKES CARE OF IT
#resource "aws_security_group_rule" "haproxy_to_nlb2stream2_backend" {
  #security_group_id         = "${var.nlb2stream2["backend_sg_id"]}"
  #description               = "ALLOW HAPROXY TO ACCESS BACKEND"
  #type                      = "ingress"
  #from_port                 = "${ lookup( var.nlb2stream2, "backend_port", "80" ) }"
  #to_port                   = "${ lookup( var.nlb2stream2, "backend_port", "80" ) }"
  #protocol                  = "tcp"
  #source_security_group_id  = "${module.haproxy.sg_id}"
#}
output "nlb2stream2_backend_port" { value = "${lookup( var.nlb2stream2, "backend_port", "80" ) }" } 
locals {
  nlb2stream2_url_list      = "${ formatlist( "http://%s:%s", aws_route53_record.nlb2_cname.fqdn, aws_lb_listener.nlb2stream2.*.port ) }"
}
output "nlb2stream2_url_list"     { value = "${local.nlb2stream2_url_list}" }
