locals {

  ##  CONVENIENT MAP WRAPPING UP STRING VARS FROM THE ENV CONTEXT
  ##  NOTE: UNDER TF11, YOU CANNOT RELIABLY PUT AN INTEGER VARIABLE IN A MAP LIKE THIS
  ##  THEN PASS THE MAP TO A MODULE AND USE THAT INTEGER VARIABLE TO 'COUNT' A RESOURCE
  ##  TODO(TF12): CHANGE TO EITHER DATA-ONLY MODULE OR COMPLEX OBJECT
  env_strings                                 = {
    aws_account_id                            = "${var.aws_account_id}"
    aws_region                                = "${var.primary_aws_region}"
    org                                       = "${var.org}"
    env                                       = "${var.env}"
    org-env                                   = "${var.org}-${var.env}"
    org_env                                   = "${var.org}_${var.env}"
    default_ec2_instance_type                 = "${var.default_ec2_instance_type}"
    default_root_volume_size                  = "${var.default_root_volume_size}"
    default_root_volume_type                  = "${var.default_root_volume_type}"
    default_root_volume_iops                  = "${var.default_root_volume_iops}"
    default_root_volume_delete_on_termination = "${var.default_root_volume_delete_on_termination}"
    default_data_volume_size                  = "${var.default_data_volume_size}"
    default_data_volume_type                  = "${var.default_data_volume_type}"
    default_data_volume_iops                  = "${var.default_data_volume_iops}"
    default_log_volume_size                   = "${var.default_log_volume_size}"
    default_log_volume_type                   = "${var.default_log_volume_type}"
    default_log_volume_iops                   = "${var.default_log_volume_iops}"
    default_addl_volume_size                  = "${var.default_addl_volume_size}"
    default_addl_volume_type                  = "${var.default_addl_volume_type}"
    default_addl_volume_iops                  = "${var.default_addl_volume_iops}"
    ebs_vol_mount_root                        = "/srv/${var.org}"
    ec2_key                                   = "${var.ec2_key}"
    default_redis_node_type                   = "${var.default_redis_node_type}"
    default_rds_instance_class                = "${var.default_rds_instance_class}"
    aws_account_id                            = "${var.aws_account_id}"
    aws_region                                = "${var.primary_aws_region}"
    public_parent_domain_ID                   = "${var.public_parent_domain_ID}"
    public_subdomain                          = "${var.env}.${var.public_parent_domain}"
    #root_acm_pca_arn                          = "${var.root_acm_pca_arn}" # DISABLED - TOO EXPENSIVE
    #acm_pca_subject_common_name               = "${}"
  }

  ##  UNIVERSAL RESOURCE TAG MAP
  ##  EXCLUDES NAME IN CASE YOU WANT TO TAG A RESOURCE WITH A MORE SPECIFIC NAME
  ##  CAN BE SAFELY PASSED TO MODULES BECAUSE WE NEVER PERFORM INTERPOLATIONS OR COMPUTATIONS ON TAGS
  tags                          = {
    org                         = "${var.org}"
    env                         = "${var.env}"
    billing_code                = "${var.billing_code}"
    owner                       = "${var.owner}"
    tf_managed                  = "true"
  }

  ##  TERRAFORM CONFIG VALUES
  ##  USED BY THE OHAI/TERRAFORM PLUGIN TO READ THE TF STATE
  terraform_strings             = {
    tfstate_s3_url              = "s3://${var.tfstate_s3_bucket}/${var.tfstate_key}"
    tfstate_s3_bucket           = "${var.tfstate_s3_bucket}"
    tfstate_s3_bucket_region    = "${var.tfstate_s3_bucket_region}"
    tfstate_key                 = "${var.tfstate_key}"
    tfstate_ddb_lock_table      = "${var.tfstate_ddb_lock_table}"
  }

}
