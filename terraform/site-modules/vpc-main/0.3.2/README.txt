The "vpc-main" site-module invokes the bitpusher-terraform-reference//vpc-net/vpc library module
to create the main/primary VPC for an environment.

The "main" signifier allows the distinction between the main VPC and other, more specialized
VPCs in a multi-VPC environment. If you are 100% certain that you'll never need more than one
VPC in your environment, then "vpc-main" could be collapsed down to just "vpc".

In this example, a security group named "main-admin" is also created in this site-module, and
its id exported up to the top-level context. This security group is intended to be attached to
all EC2 instances in the environment, for allowing access from the bastion(s) and monitoring
systems.
