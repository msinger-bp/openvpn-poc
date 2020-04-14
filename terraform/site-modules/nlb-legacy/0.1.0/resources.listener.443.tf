##  NLB:443 -> HAPROXY:8090

resource "aws_lb_listener" "443" {
  load_balancer_arn         = "${aws_lb.nlb.arn}"
  port                      = "443"
  protocol                  = "TCP"
  default_action {
    type                    = "forward"
    target_group_arn        = "${var.haproxy-legacy_tg_8090-1_arn}"
  }
}

