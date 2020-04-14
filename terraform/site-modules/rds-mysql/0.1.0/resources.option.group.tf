##  NOTE: DESTROYING A DB OPTION GROUP CAN TAKE A LONG TIME
##  DISABLING OPTION GROUPS UNTIL WE FIND A COMPELLING NEED FOR THEM
##  https://github.com/terraform-providers/terraform-provider-aws/issues/4597
##  
#resource "aws_db_option_group" "this" {
  #count                                  = "${var.create ? 1 : 0}"
  #name                                  = "${local.org-env-name}"
  #option_group_description              = "${local.org-env-name}"
  #engine_name                           = "<mysql|postgres>"
  #engine_major_version                  = "${var.major_engine_version}"
  #option                                = ["${var.options}"]
  #tags                                  = "${local.tags_w_name}"
  #lifecycle {
    #create_before_destroy               = "true"
  #}
#}
