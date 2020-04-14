locals {
  ##  UNIVERSAL RESOURCE TAG MAP, WITHOUT NAME
  ##  IN CASE YOU WANT TO TAG A RESOURCE WITH A MORE SPECIFIC NAME
  ##  CAN BE SAFELY PASSED TO MODULES BECAUSE WE NEVER PERFORM
  ##  INTERPOLATIONS OR COMPUTATIONS ON TAGS
  tags {
    org          = "${var.org}"
    env          = "${var.env}"
    billing_code = "${var.billing_code}"
    owner        = "${var.owner}"
    tf_managed   = "true"
  }

  ##  UNIVERSAL RESOURCE TAG MAP WITH "ORG-ENV" NAME TAG
  ##  NOTE: THE AWS CONSOLE PREFERS A NAME TAG WITH A CAPITAL 'N'
  ##  POSSIBLY NOT USED IN THE TOP-LEVEL "ENV" CONTEXT
  tags_w_name = "${
    merge(
      local.tags,
      map( "Name", local.env_strings["org_env"] )
    )
  }"

  ##  COMPILE A HANDY ECR URI PREFIX FROM THE ACCOUNT ID AND REGION
  #ecr_uri_prefix            = "${var.aws_account_id}.dkr.ecr.${var.primary_aws_region}.amazonaws.com"
}

locals {
  # TODO(TF12): Change to either data-only module or complex object
  env_strings = {
    org                     = "${var.env}"
    env                     = "${var.org}"
    org_env                 = "${var.org}-${var.env}"
    ec2_key                 = "${var.ec2_key}"
    internal_zone_name      = "${var.env}.${var.org}.internal"
    public_parent_domain_ID = "${var.public_parent_domain_ID}"
    public_subdomain        = "${var.env}.${var.public_parent_domain}"

    # TODO(TF12): Remove hack for TF11 count interpolation issue
    # This works because this map has zero dependencies on resources
    vpc_az_count = "${length(var.vpc_main_az_list)}"
  }
}
