locals {

  ##  HANDY NAMES
  org_env       = "${var.org}-${var.env}"
  env_name      = "${var.env}-${var.name}"
  org_env_name  = "${var.org}-${var.env}-${var.name}"

  ##  HANDY TAG MAP WITH ADDITIONAL SIMPLE NAME TAG "org-env-name"
  tags_w_name   = "${ merge( var.tags, map( "Name", "${local.org_env_name}" ) ) }"

}
