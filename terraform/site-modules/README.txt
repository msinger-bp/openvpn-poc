SITE-MODULE DIRECTORY

A "site module" is a collection of Terraform resources, external "library" module instantiations, and data objects that collectively represent a functional subset or "stack" in an environment. The resources in a site-module collectively serve a specific purpose in a specific customer context/application. Examples might include:

  * an RDS database cluster with associated subnet cluster, parameter groups, security groups, and rules
  * a cluster of EC2 instances fronted by an ALB including subnets, target groups, security groups, iam profiles/roles, listeners, alb rules, etc
  * an ECS cluster including an ALB, host instances, ASG, services, security groups, etc
  * a set of EC2 clusters and ALBs for a specific purpose, such as monitoring
  * an NLB and associated EC2 cluster running HAProxy
  * an Elasticache Redis cluster and associated EC2 worker pool clusters

Each site module should be invoked/instantiated by a single stanza in <env>.modules.tf in the env dir (~/terraform/env/<name>). This way, stacks can be turned on and off by commenting out the stanza. They can also be destroyed or created with targetd Terraform commands like "terraform (apply|destroy) -target=module.<site_module>".

Parameters that are expected to be consistent across all environments in an organization should be defined in the site modules. For example:

  * The primary/main database of an application might be called "appdb", and this name might be consistent between dev|stage|prod environments. This literal string should therefore be defined in the site-module. The actual name of the RDS instance/cluster will have the environment and organization name prepended like "customer-dev-appdb", but the "appdb" string will not change between dev|stage|prod.
  * A cluster of EC2 instances for batch processing might be called "batch", and depend on a Chef role called "batch-server". This cluster would be defined in a site-module called "batch" or "batch-servers". The "batch" name literal and the "batch-server" Chef role are not expected to be different between dev|stage|prod environments, so these should be defined in the site module.

Parameters that are expected to differ between environments are be defined in the terraform.tfvars file in the env dir. For example:

  * default EC2 key (should be different for dev and prod for security)
  * AWS account ID and region (dev and prod should be in different accounts)
  * billing code (accounting may want to separate dev from prod expenses)
  * Internal DNS zone (should be different for dev and prod)
  * instance counts and types (typically fewer instances in dev than in stage/prod)
  * ebs volume size/type/iops (smaller, slower, and cheaper in dev)
  * RDS instance class, replica count ("")
  * Elasticache node type ("")

Outputs created by modules that are required by other modules are exported ("output") from the module where they are created and fed into dependent modules as input parameters. For example:

  * security group ids
  * IAM profile ARNs
  * VPC resources
    * route table ids
    * availability zones
    * internal Route53 zone id


