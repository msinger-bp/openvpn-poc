terraform {
  required_version = "~> 0.11.14"

  backend "s3" {
    region         = "us-west-2"
    bucket         = "nexia-dev-terraform"
    key            = "aris.tfstate"
    dynamodb_table = "dev-terraform-aris"
    encrypt        = false                 # TODO: Use KMS encryption and key rotation

    # TODO: assume role
  }
}

provider "aws" {
  version = "~> 2.17"
  region  = "us-west-2"

  # TODO: assume role
}

provider "template" {
  version = "~> 2.1"
}

locals {
  # TODO Use consistent prefix for variable names, or remove redundant prefixes
  terraform_strings = {
    tf_s3_state_url          = "s3://${var.s3_tfstate_bucket}/${var.tfstate_key}"
    s3_tfstate_bucket        = "${var.s3_tfstate_bucket}"
    s3_tfstate_bucket_region = "${var.s3_tfstate_bucket_region}"
    tfstate_key              = "${var.tfstate_key}"
    tfstate_ddb_lock_table   = "${var.tfstate_ddb_lock_table}"
  }
}
