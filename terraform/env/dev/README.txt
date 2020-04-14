CREATE AND BOOTSTRAP NEW CHEF-INTEGRATED ENVIRONMENT

# CREATE S3 REMOTE STATE RESOURCES (DDB TABLE AND S3 BUCKET), IF NECESSARY

  * We usually configure one DDB table and one S3 bucket per AWS account

  * Use the S3 and DDB consoles

  * Or, use Aris's handy aws cli commands:

    ```
    set bucket <state_bucket>
    set lock_table <dynamodb_table>
    aws s3 mb s3://$bucket
    aws s3api put-bucket-versioning --bucket $bucket --versioning-configuration "Status=Enabled"
    aws dynamodb create-table \
        --table-name "$lock_table" \
        --key-schema "AttributeName=LockID,KeyType=HASH" \
        --attribute-definitions "AttributeName=LockID,AttributeType=S" \
      --provisioned-throughput "ReadCapacityUnits=1,WriteCapacityUnits=1"
    ```

  TODO: Discuss creating and attaching IAM policies for bucket and table here vs managing with TF
 

# Create a new environment directory under terraform/env

  ```
  cd terraform/env && cp -R reference <new_env>
  ```

# Edit terraform.tf and terraform.tfvars




# INSTANTIATE THE BASE, VPC, AND CHEF-EFS MODULES

```
rm -rf .terraform # IN CASE YOU COPIED A PRE-EXISTING ENV DIR WITH LOCAL STATE, WHICH WOULD SCREW THINGS UP
terraform init
terraform apply -target=module.base -target=module.vpc-main -target=module.chef
```

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
      | wsrep_connected                  | ON                                                     |
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
