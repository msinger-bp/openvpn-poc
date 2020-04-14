#module "acm_pca" {
  #source                            = "git::ssh://git@cgit01.bitpusher.com/bp-tools/bitpusher-terraform-modules//acm/pca/subordinate/0.0.1-flux"
  #org                               = "${var.env_strings["org"]}"
  #env                               = "${var.env_strings["env"]}"
  #tags                              = "${var.tags}"
  #root_acm_pca_arn                  = "${var.env_strings["root_acm_pca_arn"]}"
  ##subject_common_name               = "${var.env_strings["pca_subject_common_name"]}"
  #subject_common_name               = "${var.env_strings["public_subdomain"]}"
#}
#output "acm_pca_arn" { value = "${module.acm_pca.arn}" }
#
#data "aws_acmpca_certificate_authority" "root" {
  #arn = "${var.root_acm_pca_arn}"
#}
#output "root_acm_pca_cert" { value = "${data.aws_acmpca_certificate_authority.root.certificate}" }
