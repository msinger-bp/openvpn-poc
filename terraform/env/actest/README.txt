# Create and bootstrap new terraform/chef-integrated environment

## Create S3 remote state resources (DDB table and S3 bucket), if necessary

  NOTE: We usually configure one DDB table and one S3 bucket per AWS account

  * The DDB table must have a single partition key "LockID" (capitalization required), type String, with default settings.

  * The S3 bucket requires no special configuration


## Create and configure a new environment directory under terraform/env

  1. Copy the reference environment directory to your new environment directory

    ```
    cd terraform/env && cp -R reference <new_env> && cd <new_env>
    ```

  2. Configure terraform.tf 

    * Must be consistent with the Terraform remote state config and AWS account id and region

  3. Configure terraform.tfvars

    * Most of the env-specific configuration variables are in terraform.tfvars

    * At the very least, you must configure the following variables:

      * env

        * The literal name of your new environment. This is used many places in the TF and Chef code.

        * It must be unique in the scope of the AWS account

        * Must be alphanumeric only, and should be short and concise

        * The Chef Environment must be named with this same string    

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

# Instantiate / Apply / Create / Deploy the Environment

  1. Delete pre-existing .terraform directory, if present. It will be re-created.

    ```
    rm -rf .terraform # IN CASE YOU COPIED A PRE-EXISTING ENV DIR WITH LOCAL STATE, WHICH WOULD SCREW THINGS UP
    terraform init
    terraform apply -target=module.base -target=module.vpc-main -target=module.chef
    ```

  2. Initialize Terraform - creates the .terraform dir and copies remote and local modules to it

    ```
    rm -rf .terraform # IN CASE YOU COPIED A PRE-EXISTING ENV DIR WITH LOCAL STATE, WHICH WOULD SCREW THINGS UP
    terraform init
    terraform apply -target=module.base -target=module.vpc-main -target=module.chef
    ```


  2. Create 


# Load the /var/chef EFS mount from the chef loader instance:
  1. SSH to the loader instance and sudo:
      * have the ec2_key loaded into your ssh-agent
      * ssh -A ubuntu@`terraform state show module.chef.module.loader-instance.aws_instance.instances | egrep '^public_ip' | awk '{print $3}'`
      * sudo -E -s # PRESERVES YOUR SSH-AGENT WHILE YOU SUDO SU -
  2. Confirm that the EFS volume is mounted correctly at /var/chef:
      * cd /var/chef
      * df . # YOU SHOULD SEE SOMETHING LIKE "fs-8439f32f.efs.us-west-2.amazonaws.com:/"
  3. Clone the chef repo
      * export GIT_SSH_COMMAND='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
      * git clone <your_chef_repo> .
  4. Check out the appropriate git branch
      * if you are developing chef resources in a non-master branch, you will have to check it out on the EFS volume on the chef-loader instance
        * git checkout <branch_name>
      * this implies that your development branch must also be pushed to your origin
  5. Stop the loader instance
      * shutdown -h now

# NOW APPLY/CREATE THE REST OF YOUR ENVIRONMENT:

```
terraform apply
```


# MANIPULATE REDIS REPLICATION GROUPS/"CLUSTERS" (SUCH AS SMIL REDIS CLUSTERS)

  * WE WANT EACH REDIS REPLICATION GROUP TO CONTAIN A PRIMARY AND A REPLICA NODE
    IN THE SAME AZ. HOWEVER, AWS INITIALLY CREATES THEM IN SEPARATE AZS.

  * FOR EACH CLUSTER, WE CAN MANUALLY ADD REPLICAS IN THE DESIRED AZ, FAILOVER TO
    THAT REPLICA, CREATE ANOTHER REPLICA IN THE DESIRED AZ, AND DELETE THE REPLICAS
    IN THE NON-DESIRED AZ.

#  BOOTSTRAP / INITIALIZE GALERA/XTRADB CLUSTER

  1. BOOTSTRAP CLUSTER ON INSTANCE-01

     1.1. service mysql stop # (if necessary)

     1.2. mysqld --initialize-insecure --user=mysql

     1.3. /etc/init.d/mysql bootstrap-pxc

     1.4. Add an SST MySQL user:

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

     ##  NOTES:
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



# DESTROY ENVIRONMENT

  * If you have enabled deletion protection on any rds instances, you will have to manually disable it before tf destroy

  * Potential errors:

    * module.xxxxxxxx.output.xxxxxx: Resource 'xxxxxxxxxxxxxx' does not have attribute 'xxxxx' for variable 'xxxxxxxxxxxxxxx'

      * TF11 bug

      * You will have to temporarily comment out the offending outputs in both the site module and the env invocation file, run `terraform init`, and re-run your destroy command

      * Remember to uncomment the outputs after your destroy has succeeded!



    * 
