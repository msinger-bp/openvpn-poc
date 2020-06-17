##  TODO: ASSUME ROLE
##  TODO: USE KMS ENCRYPTION AND KEY ROTATION

terraform {
  required_version = "~> 0.11.14"
  backend "s3" {
    region         = "us-west-2"
    bucket         = "acadience-tfstate"
    key            = "stage.tfstate"
    dynamodb_table = "acadience-tfstate-lock"
    encrypt        = false
  }
}

provider "aws" {
  allowed_account_ids = [
    "695990525005"
  ]
  region  = "us-west-2"
}

provider "template" {
}
