locals {

  ##  HANDY NAMES WITH HYPHENS
  org-env                = "${var.env_strings["org-env"]}"
  ##  HANDY NAMES WITH UNDERSCORES
  org_env                = "${var.env_strings["org_env"]}"

  ##  HANDY TAG MAP WITH ADDITIONAL SIMPLE NAME TAG "org-env-name"
  tags_w_name                 = "${ merge( var.tags, map( "Name", "${local.org-env}" ) ) }"

}
