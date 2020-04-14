##  BASE MODULE
##
##  THE "BASE" SITE-MODULE IS INTENDED TO CREATE RESOURCES THAT ARE ANY OF THE FOLLOWING:
##  
##    * NOT DEPENDENT ON ANY VPC
##    * USED IN MULTIPLE VPCS IN THE SAME ENVIRONMENT
##    * REQUIRED TO PRE-EXIST BEFORE CREATING VPCS
##    * REQUIRE MANUAL CONFIGURATION OR SETUP BEFORE CREATING AN ENVIRONMENT AND IT'S VPCS
##  
##  CURRENTLY, THE ONLY SIGNIFICANT RESOURCES CREATED IN THE BASE SITE-MODULE ARE:
##  
##    * CLOUDWATCH LOGS GROUP
##    * PUBLIC ROUTE53 ZONE
##  
##  IN THE FUTURE, THERE MAY BE IAM ENTITIES, THIRD-PARTY SERVICE ACCOUNTS,
##  SECURITY KEYS, TOKENS, CREDENTIALS, ETC THAT COULD BE CREATED IN THIS MODULE

module "base" {
  source                    = "../../site-modules/base/0.3.0"
  #root_acm_pca_arn          = "${var.root_acm_pca_arn}"
  env_strings               = "${local.env_strings}"
  terraform_strings         = "${local.terraform_strings}"
  tags                      = "${local.tags}"
  ##  TODO(TF12): THE ABOVE BECOMES:
  # env                     = module.env
  # terraform               = module.terraform
}

# TODO(TF12): WE CAN REPLACE THE LOCAL MAP WITH DIRECT MODULE PASS-THRU
locals {
  base_strings                            = {
    default_ami_id                        = "${module.base.ami_ubuntu}"
    public_subdomain_id                   = "${module.base.public_subdomain_id}"
    iam-policy_cloudwatch-read-only_arn   = "${module.base.iam-policy_cloudwatch-read-only_arn}"
    iam-policy_cloudwatch-read-only_name  = "${module.base.iam-policy_cloudwatch-read-only_name}"
    public_subdomain_name                 = "${module.base.public_subdomain_name}"
    #acm_pca_arn                           = "${module.base.acm_pca_arn}"
    #root_acm_pca_cert                     = "${module.base.root_acm_pca_cert}"
  }
}

output "public_subdomain_name"          { value = "${module.base.public_subdomain_name}" }
#output "root_acm_pca_cert"              { value = "${module.base.root_acm_pca_cert}" }
