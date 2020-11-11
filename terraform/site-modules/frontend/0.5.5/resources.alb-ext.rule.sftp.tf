##  EXTERNAL ALB, PORT 443 LISTENER RULE FOR /api/sftp-auth/*
resource "aws_lb_listener_rule" "alb-ext-sftp-auth" {
  listener_arn        = "${aws_lb_listener.ext_443.arn}"
  condition {
    path_pattern {
      values          = ["/api/sftp-auth"]
    }
  }
  action {
    type              = "fixed-response"
    fixed_response {
      content_type    = "text/plain"
      message_body    = "forbidden"
      status_code     = "403"
    }
  }
}
