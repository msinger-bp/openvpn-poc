
#############################################################
##
##
##  BITPUSHER TERRAFORM REFERENCE ARCHITECTURE
##
##


#  Operator AWS IAM credentials / configuration

  * This architecture does not include definitions for operator IAM credentials, so configure your credentials in your shell however you like.

  * NOTE: AWS_REGION
    * Terraform determines the aws cli region from env/<env>/terraform.tf
    * Your "AWS_REGION" environment variable can potentially override TF and affect where resources are created
    * Either:
      * unset this environment variable
      * ensure that your "AWS_REGION" environment variable is the same as the values in terraform.tf

  * Verify your configured AWS credentials with

      # aws sts get-caller-identity


#  Running Terraform commands

   * All terraform commands for an environment must be run in the corresponding environment directory (terraform/env/<env>)

   * This document will assume that

      * your AWS credentials are loaded in your shell
      * you are running Terraform commands from the correct environment directory


#  Manage a pre-existing environment

  1. Initialize the local Terraform cache

     * This will create .terraform/ directory with a local cache of all modules and state

     # terraform init

  2. You can now run terraform apply|destroy|output|state

  * NOTE: If you are using Terraform remote state, it is always safe to delete .terraform/ and re-create with `terraform init`


#  Terraform remote state

   * Terraform remote state resources for a single environment consist of

      * one object in an S3 bucket
      * one item in a DDB table

   * We usually configure a single S3 bucket and DDB table for all environments in an account/region

   * Therefore, if there are already functioning Terraform-controlled VPC/environments in the account/region, then you don't need to create these resources

   * To manually create the S3 remote state resources for a new account/region

      1. create the S3 bucket

         * should be named like "<organization>-<account_name>-<region>-tfstate" for global uniqueness and clarity
            * EX: "nexia-homeprod-us-west-2-tfstate"
         * otherwise no special configuration

      2. create the DDB table

         * same name as the S3 bucket
         * a single Primary key / Partition key called "LockID" (incl capitalization), type String
         * no sort key
         * otherwise default settings

   * Each environment dir has a "terraform.tf" file, which must contain correct tfstate configuration


#  Create and bootstrap a new environment

  1. Prepare a new environment directory

     1.1. Copy a reference or other pre-existing environment dir to a new one and cd into it

     1.2. Copy the reference environment dir or other pre-existing environment dir to your new one

        # cd terraform/env && cp -R reference <env> && cd <env>

     1.3. Delete local state cache, if it exists (or it will screw things up)

        # rm -rf .terraform

  2. Configure the new environment

     2.1. terraform.tf

        * terraform.backend("s3").region
           * must agree with:
              * provider("aws").region
              * "aws_primary_region" in terraform.tfvars

        * terraform.backend("s3").bucket|dynamodb_table
           * must be consistent with the Terraform remote state resources for this account/region

        * terraform.backend("s3").key
           * this string value is used by Terraform to name both:
              * the remote state S3 object key
              * the DDB remote state lock item
           * must be unique and not conflict with any other environment in this region

        * provider("aws").allowed_account_ids
           * AWS account ID
           * must agree with "aws_account_id" in terraform.tfvars

     2.2. Edit parameters in <env>/terraform.tfvars as necessary

          * env
            * The literal name of your new environment. This is used many places in the TF and Chef code.
            * It must be unique in the scope of the AWS account
            * Must be alphanumeric only, and should be short and concise
            * should be the same as the name of your environment directory
            * MUST be the same as the name of your Chef environment

          * owner
            * Should reflect the engineer or group responsible for the environment

          * billing_code
            * Should also reflect the appropriate group or project

          * aws_account_id
            * The AWS account id in which you intend to deploy the environment

          * primary_aws_region
            * The AWS region in which you intend to deploy the environment

          * ec2_key
            * You must have a copy of the public key to get access to the environment

          * vpc-main_cidr_16
            * First two octets of the VPC CIDR (x.y.0.0/16)
            * Must be unique among all VPCs in this account/region

     2.3. Modify site-module invocations in <env>/module.*.tf files, if necessary

          * You can change

            * Instance/resource counts
            * EC2/RDS/ElastiCache/etc resource types
            * EBS volume size/type/iops
            * service ports
            * chef roles
            * RDS replica counts, MySQL versions, MySQL parameters, allocated storage, storage type, multi-az, etc

          * Disable entire module invocations, if necessary

            * comment-out the invocation block and associated outputs in the module.<name>.tf file
            * OR: mv module.<name>.tf module.<name>.tf.bak
            * NOTE: if you do this, you may also have to
              * reconcile outputs to other modules that are dependent on the outputs of the disabled module
              * comment out corresponding values in aggregate outputs in env/<env>/outputs.*.tf

          * NOTE: for details about invoking a specific site-module, refer to
            * terraform/site-module/<name>/vars.tf
            * terraform/site-module/<name>/examples/README.txt
            * terraform/site-module/<name>/examples/<example_invocation_file>.tf

  3. Initialize the local Terraform cache (.terraform/)

     # terraform init

  4. Instantiate the base, vpc-main, and chef-efs modules

     # terraform apply -target=module.base -target=module.vpc-main -target=module.chef

  5. Load the /var/chef EFS mount from the chef-loader instance

     * NOTE: This enables instances to run chef-client immediately after creation

     5.1. SSH to the loader instance and sudo

        5.1.1. have the correct ec2_key loaded into your ssh-agent

        5.1.2. SSH to the chef-loader instance with this handy command

           # ssh -A ubuntu@`terraform state show module.chef.module.loader-instance.aws_instance.instances | egrep '^public_ip' | awk '{print $3}'`

        5.1.3. Assume root while preserving your ssh-agent

           # sudo -E -s

     5.2. Confirm that the EFS volume is mounted correctly at /var/chef

        # cd /var/chef && df .
        
        * NOTE: You should see something like "fs-8439f32f.efs.us-west-2.amazonaws.com:/"

     5.3. Clone the chef repo

        # export GIT_SSH_COMMAND='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' git clone <your_chef_repo> .

     5.4. Check out the appropriate git branch, if necessary

        * if you are developing chef resources in a non-master branch, you will have to check it out on the EFS volume on the chef-loader instance

          # git checkout <branch_name>

        * NOTE: this implies that your development branch must also be pushed to your origin

     5.4. Stop the loader instance

        # shutdown -h now

  6. Instantiate the rest of the environment

      # terraform apply


#  Manipulate redis replication groups/"clusters"

  * (such as Nexia-smil redis clusters)
  * We want each redis replication group to contain a primary and a replica node in the same az.
  * However, aws initially creates them in separate azs.
  * For each cluster, we can manually add replicas in the desired az, failover to that replica, create another replica in the desired az, and delete the replicas in the non-desired az.


#  Bootstrap / initialize Galera/XtraDB cluster

  1. Bootstrap cluster on instance-01

     1.1. stop mysql, if necessary

        service mysql stop

     1.2. mysqld --initialize-insecure --user=mysql

     1.3. /etc/init.d/mysql bootstrap-pxc

     1.4. Add an SST MySQL user

        # mysql
        mysql@pxc1> CREATE USER 'sstuser'@'localhost' IDENTIFIED BY 'passw0rd';
        mysql@pxc1> GRANT RELOAD, LOCK TABLES, PROCESS, REPLICATION CLIENT ON *.* TO 'sstuser'@'localhost';
        mysql@pxc1> FLUSH PRIVILEGES;
        mysql@pxc1> quit;

        # mysql -e "CREATE USER 'sstuser'@'localhost' IDENTIFIED BY 'passw0rd'"
        # mysql -e "GRANT RELOAD, LOCK TABLES, PROCESS, REPLICATION CLIENT ON *.* TO 'sstuser'@'localhost'"
        # mysql -e "FLUSH PRIVILEGES"
        # mysql -e "select User, Host from user where User = 'sstuser'" mysql

  2. ADD _ALL_ OTHER NODES, ONE AT A TIME

     2.1. service mysql stop # (if necessary)

     2.2. mysqld --initialize-insecure --user=mysql

     2.3. service mysql start

     ##  NOTES
     ##    * NEW NODES THAT ARE PROPERLY CONFIGURED ARE PROVISIONED AUTOMATICALLY.
     ##    * WHEN YOU START A NODE WITH THE ADDRESS OF AT LEAST ONE OTHER RUNNING NODE IN THE WSREP_CLUSTER_ADDRESS VARIABLE, IT AUTOMATICALLY JOINS THE CLUSTER AND SYNCHRONIZES WITH IT.

  3. FROM <INSTANCE>-01, VERIFY CLUSTER IS HEALTHY

      # mysql
      ...
      mysql> show status like 'wsrep%';
      +----------------------------------+--------------------------------------------------------+
      | Variable_name                    | Value                                                  |
      +----------------------------------+--------------------------------------------------------+
      ...
      | wsrep_local_state_comment        | Synced                                                 |
      ...
      | wsrep_incoming_addresses         | 10.19.111.80:3306,10.19.111.140:3306,10.19.111.22:3306 |
      | wsrep_cluster_weight             | 3                                                      |
      | wsrep_desync_count               | 0                                                      |
      ...
      | wsrep_cluster_conf_id            | 3                                                      |
      | wsrep_cluster_size               | 3                                                      |
      ...
      | wsrep_cluster_status             | Primary                                                |
      1G| wsrep_connected                  | ON                                                     |
      ...
      | wsrep_ready                      | ON                                                     |
      +----------------------------------+--------------------------------------------------------+
      ...
      # quit

  3. RESTART NODE #01 IN NORMAL MODE

     3.1. service mysql stop && service mysql start

       ##  NOTE: 'restart' DOESN'T WORK



 Destroy environment

  * If you have enabled deletion protection on any rds instances, you will have to manually disable it before tf destroy

  * Potential errors

    * module.xxxxxxxx.output.xxxxxx: Resource 'xxxxxxxxxxxxxx' does not have attribute 'xxxxx' for variable 'xxxxxxxxxxxxxxx'

      * TF11 bug

      * You will have to temporarily comment out the offending outputs in both the site module and the env invocation file, run `terraform init`, and re-run your destroy command

      * Remember to uncomment the outputs after your destroy has succeeded!

    * module.haproxy-legacy.module.haproxy.module.cluster_az_2.aws_placement_group.this (destroy): 1 error occurred:
    * aws_placement_group.this: unexpected state 'available', wanted target 'deleted'. last error: %!s(<nil>)

      * placement group has been deleted (verify in console), but TF can't figure it out
      * terraform refresh does not fix the issue
      * To Fix:
        1. Verify that the placement group has been deleted using the console or cli
        2. Delete the resource in the state
           ```
           tf state rm module.haproxy-legacy.module.haproxy.module.cluster_az_2.aws_placement_group.this
           1 items removed.
           Item removal successful.
           ```
        3. Verify resource is removed from state
           ```
           tf state list | grep 'module.haproxy-legacy.module.haproxy.module.cluster_az_2.aws_placement_group.this'  ##  RETURNS NOTHING
           ```

