#
# Cookbook Name:: bp-nagios
# Recipe:: default
#
# Copyright 2015, BitPusher, LLC
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'
include_recipe 'apache2::mpm_prefork'
include_recipe 'nagios'
include_recipe 'nagios::pagerduty'

nagios_command 'notify-host-by-pagerduty' do
  options 'command_line' => '/usr/lib/nagios/plugins/notify_pagerduty.pl enqueue -f pd_nagios_object=host -f CONTACTPAGER="$CONTACTPAGER$" -f NOTIFICATIONTYPE="$NOTIFICATIONTYPE$" -f HOSTNAME="$HOSTNAME$" -f HOSTGROUP="$HOSTGROUPNAMES$" -f HOSTSTATE="$HOSTSTATE$" -f HOSTNOTES="$HOSTNOTES$" -f HOSTGROUPNOTESURL="$HOSTGROUPNOTESURL$"'
end

nagios_command 'notify-service-by-pagerduty' do
  options 'command_line' => '/usr/lib/nagios/plugins/notify_pagerduty.pl enqueue -f pd_nagios_object=service -f CONTACTPAGER="$CONTACTPAGER$" -f NOTIFICATIONTYPE="$NOTIFICATIONTYPE$" -f HOSTNAME="$HOSTNAME$" -f HOSTGROUP="$HOSTGROUPNAMES$"  SERVICEDESC="$SERVICEDESC$" -f SERVICESTATE="$SERVICESTATE$" -f HOSTNOTES="$HOSTNOTES$" -f HOSTGROUPNOTESURL="$HOSTGROUPNOTESURL$"'
end

nagios_command 'host_notify_by_email' do
  options 'command_line' => '/usr/bin/printf "%b" "$LONGDATETIME$\n\n$HOSTALIAS$ $NOTIFICATIONTYPE$ $HOSTSTATE$\n\n$HOSTOUTPUT$\n\nLogin: ssh://$HOSTNAME$\n\n$HOSTNOTES$\n\n" | ' + node['nagios']['server']['mail_command'] + ' -s "$NOTIFICATIONTYPE$ - $HOSTALIAS$ $HOSTSTATE$!" $CONTACTEMAIL$'
end

nagios_command 'service_notify_by_email' do
  options 'command_line' => '/usr/bin/printf "%b" "$LONGDATETIME$ - $SERVICEDESC$ $SERVICESTATE$\n\n$HOSTALIAS$  $NOTIFICATIONTYPE$\n\n$SERVICEOUTPUT$\n\nLogin: ssh://$HOSTNAME$\n\n$HOSTNOTES$\n\n" | ' + node['nagios']['server']['mail_command'] + ' -s "** $NOTIFICATIONTYPE$ - $HOSTALIAS$ - $SERVICEDESC$ - $SERVICESTATE$" $CONTACTEMAIL$'
end

cookbook_file 'check_elasticsearch' do
  path "#{node['nagios']['plugin_dir']}/check_elasticsearch"
  mode '0755'
  owner 'root'
  group 'root'
  action :create
  source 'check_elasticsearch'
end

cookbook_file 'check_mongodb.py' do
  path "#{node['nagios']['plugin_dir']}/check_mongodb.py"
  mode '0755'
  owner 'root'
  group 'root'
  action :create
  source 'check_mongodb.py'
end

cookbook_file 'check_salt.py' do
  path "#{node['nagios']['plugin_dir']}/check_salt.py"
  mode '0755'
  owner 'root'
  group 'root'
  action :create
  source 'check_salt.py'
end

sudo 'check_salt' do
  user 'nagios'
  runas 'root'
  commands ["#{node['nagios']['plugin_dir']}/check_salt.py"]
  defaults ['!requiretty','env_reset']
  nopasswd true
end

# check_multi Nagios plugin.
package 'nagios-plugin-check-multi'
directory "#{node['nagios']['config_dir']}/check_multi" do
  owner node['nagios']['user']
  group node['nagios']['group']
end

cookbook_file "#{node['nagios']['config_dir']}/check_multi/elasticsearch.cmd" do
  mode '0644'
  owner 'nagios'
  group 'nagios'
  action :create
  source 'elasticsearch.cmd'
end

package 'libredis-perl'

cookbook_file 'check_redis' do
  path "#{node['nagios']['plugin_dir']}/check_redis"
  mode '0755'
  owner 'root'
  group 'root'
  action :create
  source 'check_redis'
end

# Elasticsearch checks and dependancies
cookbook_file 'nagioscheck.py' do
  path  '/usr/local/lib/python2.7/dist-packages/nagioscheck.py'
  mode  0644
  owner 'root'
  group 'root'
  action :create
  source 'nagioscheck.py'
end

%w{check_es_cluster_status.py check_es_jvm_usage.py check_es_nodes.py check_es_split_brain.py check_es_unassigned_shards.py}.each do |iter|
  cookbook_file iter do
    path "#{node['nagios']['plugin_dir']}/#{iter}"
    mode '0755'
    owner 'root'
    group 'root'
    action :create
    source iter
  end
end

package 'python-memcache'

cookbook_file 'check_memcache' do
  path "#{node['nagios']['plugin_dir']}/check_memcache"
  mode '0755'
  owner 'root'
  group 'root'
  action :create
  source 'check_memcache'
end

nagios_service "elasticsearch" do
  options "description"           => "ElasticSearch",
          "hostgroup_name"        => "elasticsearch-prod",
          "service_template"      => "default-service",
          "check_command"         => "check_elasticsearch",
          'notifications_enabled' => 0
end

nagios_command "check_elasticsearch" do
  options "command_line" => "$USER1$/check_elasticsearch -H $HOSTADDRESS$ -P 9200 -u nagios -p does_not_matter_which_password"
end

nagios_service "elasticsearch_cluster" do
  options "description"           => "ElasticSearch Cluster",
          "hostgroup_name"        => "monitoring",
          "service_template"      => "default-service",
          "check_command"         => "check_elasticsearch_multi"
end

nagios_command "check_elasticsearch_multi" do
  options "command_line" => "$USER1$/check_multi -f #{node['nagios']['config_dir']}/check_multi/elasticsearch.cmd -n 'ElasticSearch Cluster Health'"
end

nagios_service "all_disk" do
  options "description" => "Memory",
          "hostgroup_name" => "base",
          "service_template" => "default-service",
          "check_command" => "all_disk"
end

nagios_command "all_disk" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_all_disks -t 20"
end

nagios_command "ro_mounts" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_ro_mounts -t 20"
end

nagios_service "ro_mounts" do
  options "description"           => "Read Only mounts",
          "hostgroup_name"        => "elasticsearch-prod",
          "service_template"      => "default-service",
          "check_command"         => "ro_mounts"
end

nagios_command "check_mongodb" do
  options "command_line" => "$USER1$/check_mongodb.py -H $HOSTADDRESS$ -A connect -P 27017 -W 1 -C 2"
end

nagios_service "check_mongodb" do
  options "description" => "check MongoDB",
          "hostgroup_name" => "gmail-service-mongodb",
          "service_template" => "default-service",
          "check_command" => "check_mongodb"
end

nagios_service "check_mongodb_backups" do
  options "description" => "mongodb backups",
          "hostgroup_name" => "gmail-service-mongodb",
          "service_template" => "default-service",
          "check_command" => "check_mongodb_backups",
          "notification_period" => "bitpusher_business_hours"
end

nagios_command "check_mongodb_backups" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_mongodb_backups"
end

nagios_service "check_nodejs_http" do
  options "description" => "check nodejs",
          "hostgroup_name" => "gmail-service-app",
          "service_template" => "default-service",
          "check_command" => "check_nodejs"
end

nagios_command "check_nodejs" do
  options "command_line" => "$USER1$/check_http -H $HOSTADDRESS$ -p 3000"
end

nagios_service "mysql" do
  options "description" => "MySQL Database Server",
          "hostgroup_name" => "db",
          "service_template" => "default-service",
          "check_command" => "mysql"
end

nagios_command "mysql" do
  options "command_line" => "$USER1$/check_mysql -H $HOSTADDRESS$ -u nagios -p #{node['bp-nagios']['mysql_password']}"
end

nagios_service "pmp_innodb" do
  options "description" => "InnoDB Table Status",
          "hostgroup_name" => "percona",
          "service_template" => "default-service",
          "check_command" => "pmp_innodb"
end

nagios_command "pmp_innodb" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_pmp_innodb -t 20"
end

nagios_service "pmp_num_threads" do
  options "description" => "MySQL Number Threads Running",
          "hostgroup_name" => "percona",
          "service_template" => "default-service",
          "check_command" => "pmp_num_threads"
end

nagios_command "pmp_num_threads" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_pmp_num_threads -t 20"
end

nagios_service "pmp_processlist" do
  options "description" => "MySQL Process List",
          "hostgroup_name" => "percona",
          "service_template" => "default-service",
          "check_command" => "pmp_processlist",
          "retry_interval" => 2
end

nagios_command "pmp_processlist" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_pmp_processlist -t 20"
end

nagios_service "pmp_repl_delay" do
  options "description" => "MySQL Replcation Delay",
          "hostgroup_name" => "percona",
          "service_template" => "default-service",
          "max_check_attempts" => "5",
          "retry_interval" => "60",
          "check_command" => "pmp_repl_delay"
end

nagios_command "pmp_repl_delay" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_pmp_repl_delay -t 20"
end

nagios_service "pmp_slave_exec" do
  options "description" => "MySQL Slave Exec Mode",
          "hostgroup_name" => "percona",
          "service_template" => "default-service",
          "check_command" => "pmp_slave_exec"
end

nagios_command "pmp_slave_exec" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_pmp_slave_exec -t 20"
end

nagios_service "pmp_threads_vs_connections" do
  options "description" => "MySQL Number Threads vs Available Connections",
          "hostgroup_name" => "percona",
          "service_template" => "default-service",
          "check_command" => "pmp_threads_vs_connections"
end

nagios_command "pmp_threads_vs_connections" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_pmp_threads_vs_connections -t 20"
end

nagios_service "pmp_wsrep_state" do
  options "description" => "MySQL Replication State",
          "hostgroup_name" => "percona",
          "service_template" => "default-service",
          "check_command" => "pmp_wsrep_state"
end

nagios_command "pmp_wsrep_state" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_pmp_wsrep_state -t 20"
end

nagios_service "redis" do
  options "description" => "Redis",
          "hostgroup_name" => "redis",
          "service_template" => "lazy-service",
          "check_command" => "redis"
end

nagios_command "redis" do
  options "command_line" => "$USER1$/check_redis -H $HOSTNAME$ -p 6379 -w 15 -c 60"
end

# Remove salt check as it doesn't work and just spams us incessantly
#nagios_service "salt" do
#  options "description" => "Salt Test Ping",
#          "hostgroup_name" => "base",
#          "service_template" => "lazy-service",
#          "check_command" => "salt"
#end

nagios_command "salt" do
  options "command_line" => "sudo $USER1$/check_salt.py $HOSTALIAS$"
end

nagios_service "varnish" do
  options "description" => "Varnish",
          "hostgroup_name" => "cache",
          "service_template" => "default-service",
          "check_command" => "varnish"
end

nagios_command "varnish" do
  options "command_line" => "$USER1$/check_http -H $HOSTADDRESS$ -p80  -u /varnishcheck"
end

nagios_service "check_adam_http" do
  options "description" => "check adam",
          "hostgroup_name" => "adam-app",
          "service_template" => "default-service",
          "check_command" => "check_adam"
end

nagios_command "check_adam" do
  options "command_line" => "$USER1$/check_http -H $HOSTADDRESS$ -p 80 -u /__health_check"
end

nagios_service "wowza" do
  options "description" => "Wowza",
          "hostgroup_name" => "recording",
          "service_template" => "default-service",
          "check_command" => "wowza"
end

nagios_command "wowza" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_proc_wowza -t 20"
end

nagios_service "load" do
  options "description" => "Load",
          "hostgroup_name" => "base",
          "service_template" => "default-service",
          "check_command" => "load"
end

nagios_command "load" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_load -t 20"
end

nagios_service "mem" do
  options "description" => "Memory",
          "hostgroup_name" => "base",
          "service_template" => "default-service",
          "check_command" => "mem"
end

nagios_command "mem" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_memory -t 20"
end

nagios_service "memcache" do
  options "description" => "Memcache",
          "hostgroup_name" => "memcache",
          "service_template" => "lazy-service",
          "check_command" => "memcache"
end

nagios_command "memcache" do
  options "command_line" => "$USER1$/check_memcache -H $HOSTNAME$"
end

nagios_service "nfs" do
  options "description" => "NFS Server",
          "hostgroup_name" => "store",
          "service_template" => "default-service",
          "check_command" => "nfs"
end

nagios_command "nfs" do
  options "command_line" => "$USER1$/check_tcp -H $HOSTADDRESS$ -p 2049"
end

nagios_service "ntp" do
  options "description" => "NTP Server",
          "hostgroup_name" => "ntp",
          "service_template" => "default-service",
          "check_command" => "ntp"
end

nagios_command "ntp" do
  options "command_line" => "$USER1$/check_ntp_peer -H $HOSTADDRESS$ -w1 -c 5 -t 20"
end

nagios_service "ntpd_time" do
  options "description" => "NTP Time",
          "hostgroup_name" => "base",
          "service_template" => "default-service",
          "check_command" => "ntpd_time"
end

nagios_command "ntpd_time" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_ntpd_time -t 20"
end

nagios_service "proc_keepalived" do
  options "description" => "KeepaliveD Process",
          "hostgroup_name" => "keepalived",
          "service_template" => "default-service",
          "check_command" => "proc_keepalived"
end

nagios_command "proc_keepalived" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_proc_keepalived -t 20"
end

nagios_service "proc_ntpd" do
  options "description" => "NTP Process",
          "hostgroup_name" => "base",
          "service_template" => "default-service",
          "check_command" => "proc_ntpd"
end

nagios_command "proc_ntpd" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_proc_ntpd -t 20"
end

nagios_service "sshd" do
  options "description" => "SSH Daemon",
          "hostgroup_name" => "base",
          "service_template" => "lazy-service",
          "check_command" => "sshd"
end

nagios_command "sshd" do
  options "command_line" => "$USER1$/check_ssh $HOSTADDRESS$"
end

nagios_service "swap" do
  options "description" => "Swap",
          "hostgroup_name" => "base",
          "service_template" => "default-service",
          "check_command" => "swap"
end

nagios_command "swap" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_swap -t 20"
end

nagios_service "tmpfs" do
  options "description" => "Tmpfs",
          "hostgroup_name" => "base",
          "service_template" => "default-service",
          "check_command" => "tmpfs"
end

nagios_command "tmpfs" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_tmpfs -t 20"
end

# Resque monitoring
%w{core linker}.each do |iter|
  cookbook_file "#{node['nagios']['plugin_dir']}/check_resque_queue_#{iter}.rb" do
    mode '0755'
    owner 'root'
    group 'root'
    action :create
    source "check_resque_queue_#{iter}.rb"
  end

  nagios_command "check_resque_queue_#{iter}" do
    options 'command_line' => "/usr/lib/nagios/plugins/check_resque_queue_#{iter}.rb -q $ARG1$ -w $ARG2$ -c $ARG3$"
  end
end

# Linker Queues
nagios_service 'access_control_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'Access Control Queue Size',
          'hostgroup_name' => 'monitoring',
          'retry_interval' => '3',
          'check_command' => 'check_resque_queue_linker!access_control!200000!250000'
end

nagios_service 'notify_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'Notify Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_linker!notify!1000!5000'
end

nagios_service 'event_creation_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'Event Creation Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_linker!event_creation!2000!2500'
end

# Core queues
nagios_service 'alertsp1_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'alertsp1 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!alertsp1!40000!75000'
end

nagios_service 'backgroundp4_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'backgroundp4 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!backgroundp4!25000!50000'
end

nagios_service 'backgroundp5_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'backgroundp5 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!backgroundp5!40000!80000'
end

nagios_service 'backgroundp6_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'backgroundp6 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!backgroundp6!60000!100000'
end

nagios_service 'cachep0_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'cachep0 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!cachep0!25000!45000'
end

nagios_service 'cachep1_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'cachep1 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!cachep1!35000!45000'
end

nagios_service 'cachep2_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'cachep2 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!cachep2!50000!60000'
end

nagios_service 'cachewarmerp8_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'cachewarmerp8 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!cachewarmerp8!20000!50000'
end

nagios_service 'elasticsearchp0_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'emailp1 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!elasticsearchp0!100000!1000000',
          'notifications_enabled' => 0
end

nagios_service 'elasticsearchp1_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'emailp1 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!elasticsearchp1!100000!1000000',
          'notifications_enabled' => 0
end

nagios_service 'elasticsearchp2_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'emailp1 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!elasticsearchp2!100000!1000000',
          'notifications_enabled' => 0
end

nagios_service 'elasticsearchp3_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'emailp1 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!elasticsearchp3!100000!1000000',
          'notifications_enabled' => 0
end

nagios_service 'emailp1_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'emailp1 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!emailp1!15000!25000'
end

nagios_service 'emailp3_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'emailp3 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!emailp3!10000!40000'
end

nagios_service 'fileprocessingp2_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'fileprocessingp2 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!fileprocessingp2!500!1000'
end

nagios_service 'fileprocessingp3_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'fileprocessingp3 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!fileprocessingp3!500!1000'
end

nagios_service 'longjobsp7_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'longjobsp7 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!longjobsp7!2500!5000'
end

nagios_service 'longjobsp8_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'longjobsp7 Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_core!longjobsp7!7500!10000'
end

# Setup notes for hosts
include_recipe 'bp-nagios::notes'
include_recipe 'bp-nagios::hostgroups'

# Set special settings for autoscaled code classes
include_recipe 'bp-nagios::autoscale'

# Analytics RedShift/DMS
include_recipe 'bp-nagios::redshift'

# RDS slave check host templates
nagios_command 'dummy_host' do
  options 'command_line' => '$USER1$/check_dummy 0 "This is a dummy check"'
end

nagios_command "rds_repl_delay" do
  options "command_line" => "$USER1$/check_mysql -H $HOSTADDRESS$ -u nagios -p #{node['bp-nagios']['rds-slave']['mysql_password']} -S -w #{node['bp-nagios']['rds-slave']['warning']} -c #{node['bp-nagios']['rds-slave']['critical']}"
end

nagios_host 'rds-slave' do
  options 'name'             => 'rds-slave',
          'register'         => 0,
          'use'              => 'server',
          'check_command'    => 'dummy_host'
end

nagios_service 'rds_repl_delay' do
  options 'description'      => 'RDS Replcation Delay',
          'hostgroup_name'   => 'rds-slave',
          'service_template' => 'default-service',
          'check_command'    => 'rds_repl_delay'
end

nagios_timeperiod 'bitpusher_business_hours' do
  options 'alias' => '9AM to 8PM during the week',
          'times' => { 'sunday'    => '16:00-03:00',
                       'monday'    => '16:00-03:00',
                       'tuesday'   => '16:00-03:00',
                       'wednesday' => '16:00-03:00',
                       'thursday'  => '16:00-03:00',
                       'friday'    => '16:00-03:00',
                       'saturday'  => '16:00-03:00'
                     }
end

cron 'GetSSL update' do
  command "/usr/bin/getssl -u -q -a"
  minute  '15'
  hour    '4'
  user    'root'
  action  :create
end
