module "acm" {
  source                    = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//acm/cert/0.1.1"
  name                      = "${var.name}"
  domain_name               = "${var.name}.${var.base_strings["public_subdomain_name"]}"
  subject_alternative_names = "${concat([var.base_strings["public_subdomain_name"]], var.acm_additional_sans)}"
  zone_id                   = "${var.base_strings["public_subdomain_id"]}"
  org                       = "${var.env_strings["org"]}"
  env                       = "${var.env_strings["env"]}"
  tags                      = "${var.tags}"
}
