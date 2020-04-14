cookbooks/galera/README.txt
last edit 2020 Mar 06

##  BOOTSTRAP / INITIALIZE GALERA/XTRADB CLUSTER

1. BOOTSTRAP CLUSTER ON INSTANCE-01

   1.1. service mysql stop # (if necessary)

   1.2. mysqld --initialize-insecure --user=mysql

   1.3. /etc/init.d/mysql bootstrap-pxc

   1.4. Add an SST MySQL user:

      * NOTE: Use the correct sst username and password if they have been changed from the defaults, which you would find in this cookbook's attributes/defaults.rb, probably
        default['galera']['sst_password']                         = 'sstpassword'

      so:

      # mysql
      mysql@pxc1> CREATE USER 'sstuser'@'localhost' IDENTIFIED BY 'sstpassword';
      mysql@pxc1> GRANT RELOAD, LOCK TABLES, PROCESS, REPLICATION CLIENT ON *.* TO 'sstuser'@'localhost';
      mysql@pxc1> FLUSH PRIVILEGES;
      mysql@pxc1> quit;

      or, alternatively:

      # mysql -e "CREATE USER 'sstuser'@'localhost' IDENTIFIED BY 'sstpassword'"
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

   3.1. mysqladmin shutdown && service mysql start


