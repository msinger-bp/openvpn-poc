locals {

  ##  HANDY NAMES WITH HYPHENS
  env-name                    = "${var.env_strings["env"]}-${var.name}"
  org-env-name                = "${var.env_strings["org-env"]}-${var.name}"
  ##  HANDY NAMES WITH UNDERSCORES
  env_name                    = "${var.env_strings["env"]}_${var.name}"
  org_env_name                = "${var.env_strings["org_env"]}_${var.name}"
  ##  HANDY NAMES WITHOUT HYPHENS OR UNDERSCORES FOR RDS INSTANCE IDENTIFIERS, WHICH CAN ONLY HAVE ALPHANUM CHARACTERS
  name_hyphenless             = "${ replace( var.name, "-", "") }"
  orgenvname                  = "${var.env_strings["org"]}${var.env_strings["env"]}${local.name_hyphenless}"

  ##  HANDY TAG MAP WITH ADDITIONAL SIMPLE NAME TAG "org-env-name"
  tags_w_name                 = "${ merge( var.tags, map( "Name", "${local.org-env-name}" ) ) }"

  ###  EFFECTIVE ENGINE VERSION
  #engine_major_minor_version  = "${var.engine_major_version}.${var.engine_minor_version}"
  #effective_engine_version    = "${ var.engine_minor_version == "" ? var.engine_major_version : local.engine_major_minor_version }"

}
