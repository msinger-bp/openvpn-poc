#resource "aws_acm_certificate" "https_443" {
  ##domain_name               = "${var.name}.${var.vpc_strings["internal_zone_name"]}"
  #domain_name               = "${module.alb.cname_short}"
  #certificate_authority_arn = "${var.base_strings["acm_pca_arn"]}"
  #tags                      = "${merge( var.tags, map( "Name", "${local.org_env_name} https/443 listener" ) ) }"
#}
###  PORT 443 LISTENER
#resource "aws_lb_listener" "https_443" {
  #load_balancer_arn         = "${module.alb.alb_arn}"
  #port                      = "443"
  #protocol                  = "HTTPS"
  #ssl_policy                = "ELBSecurityPolicy-2016-08"
  #certificate_arn           = "${aws_acm_certificate.https_443.arn}"
  #default_action {
    #type                    = "fixed-response"
    #fixed_response {
      #content_type          = "text/plain"
      #message_body          = "${local.org_env_name} listener 443 HTTPS default response"
      #status_code           = "400"
    #}
  #}
  ##default_action {
    ##type                   = "forward"
    ##target_group_arn       = "${aws_lb_target_group.instances_https_443.arn}"
  ##}
#}
