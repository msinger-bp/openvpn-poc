##  TODO: ASSUME ROLE
##  TODO: USE KMS ENCRYPTION AND KEY ROTATION

terraform {
  required_version = "~> 0.11.14"
  backend "s3" {
    region         = "us-west-2"
    bucket         = "bptfref-tfstate"
    key            = "<CHANGE_TO_ENV>.tfstate"
    dynamodb_table = "bptfref-tfstate-lock"
    encrypt        = false
  }
}

provider "aws" {
  allowed_account_ids = [
    "509819115418" # BITPUSHER TF DEV ACCOUNT
  ]
  region  = "us-west-2"
}

provider "template" {
}
