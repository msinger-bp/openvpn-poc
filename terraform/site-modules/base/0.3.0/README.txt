The "base" site-module is intended to create resources that:

  * are not dependent on any VPC
  * are used in multiple VPCs in the same environment
  * are required to pre-exist before creating VPCs

Currently, the only significant resources created in the base site-module are:

  * CloudWatch Logs group
  * Public Route53 zone

In the future, there may be IAM entities, third-party service accounts,
security keys, tokens, credentials, etc that could be created in this module.

