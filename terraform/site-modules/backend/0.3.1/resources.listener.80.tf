##  PORT 80 LISTENER
resource "aws_lb_listener" "http_80" {
  load_balancer_arn     = "${module.alb.alb_arn}"
  port                  = "80"
  protocol              = "HTTP"
  default_action {
    type                = "fixed-response"
    fixed_response {
      content_type      = "text/plain"
      message_body      = "${local.org_env_name} listener 80 default response"
      status_code       = "400"
    }
  }
  #default_action {
    #type                = "forward"
    #target_group_arn    = "${aws_lb_target_group.instances_http_80.arn}"
  #}
  ##  REDIRECT HTTP/80 TO HTTPS/443
  #default_action {
    #type                = "redirect"
    #redirect {
      #port              = "443"
      #protocol          = "HTTPS"
      #status_code       = "HTTP_301"
    #}
  #}
}
