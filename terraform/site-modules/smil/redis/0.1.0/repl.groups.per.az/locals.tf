locals {

  ##  HANDY NAMES WITH HYPHENS
  env-name      = "${var.env_strings["env"]}-${var.name}"
  org-env-name  = "${var.env_strings["org-env"]}-${var.name}"
  ##  HANDY NAMES WITH UNDERSCORES
  env_name      = "${var.env_strings["env"]}_${var.name}"
  org_env_name  = "${var.env_strings["org_env"]}_${var.name}"

  ##  HANDY TAG MAP WITH ADDITIONAL SIMPLE NAME TAG "org-env-name"
  tags_w_name   = "${ merge( var.tags, map( "Name", "${local.org-env-name}" ) ) }"

  az_abbr       = "${substr(var.target_az,-1,1)}"

}
