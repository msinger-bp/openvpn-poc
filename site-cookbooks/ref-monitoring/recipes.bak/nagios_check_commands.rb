##  DUMMY CHECK FOR TESTING
nagios_command 'check_dummy' do
  #options 'command_line' => "$USER1$/check_dummy $HOSTADDRESS$"
  options 'command_line' => '$USER1$/check_dummy 0 "This is a dummy check"'
end

nagios_command "check_elasticsearch" do
  options "command_line" => "$USER1$/check_elasticsearch -H $HOSTADDRESS$ -P 9200 -u nagios -p does_not_matter_which_password"
end

nagios_command "check_elasticsearch_multi" do
  options "command_line" => "$USER1$/check_multi -f #{node['nagios']['config_dir']}/check_multi/elasticsearch.cmd -n 'ElasticSearch Cluster Health'"
end

nagios_command "all_disk" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_all_disks -t 20"
end

nagios_command "ro_mounts" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_ro_mounts -t 20"
end

nagios_command "check_mongodb" do
  options "command_line" => "$USER1$/check_mongodb.py -H $HOSTADDRESS$ -A connect -P 27017 -W 1 -C 2"
end

nagios_command "check_mongodb_backups" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_mongodb_backups"
end

nagios_command "check_nodejs" do
  options "command_line" => "$USER1$/check_http -H $HOSTADDRESS$ -p 3000"
end

#nagios_command "mysql" do
  #options "command_line" => "$USER1$/check_mysql -H $HOSTADDRESS$ -u nagios -p #{node['bp-nagios']['mysql_password']}"
#end

nagios_command "pmp_innodb" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_pmp_innodb -t 20"
end

nagios_command "pmp_num_threads" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_pmp_num_threads -t 20"
end

nagios_command "pmp_processlist" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_pmp_processlist -t 20"
end

nagios_command "pmp_repl_delay" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_pmp_repl_delay -t 20"
end

nagios_command "pmp_slave_exec" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_pmp_slave_exec -t 20"
end

nagios_command "pmp_threads_vs_connections" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_pmp_threads_vs_connections -t 20"
end

nagios_command "pmp_wsrep_state" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_pmp_wsrep_state -t 20"
end

nagios_command "redis" do
  options "command_line" => "$USER1$/check_redis -H $HOSTNAME$ -p 6379 -w 15 -c 60"
end

nagios_command "salt" do
  options "command_line" => "sudo $USER1$/check_salt.py $HOSTALIAS$"
end

nagios_command "varnish" do
  options "command_line" => "$USER1$/check_http -H $HOSTADDRESS$ -p80  -u /varnishcheck"
end

nagios_command "check_adam" do
  options "command_line" => "$USER1$/check_http -H $HOSTADDRESS$ -p 80 -u /__health_check"
end

nagios_command "wowza" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_proc_wowza -t 20"
end

nagios_command "load" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_load -t 20"
end

nagios_command "mem" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_memory -t 20"
end

nagios_command "memcache" do
  options "command_line" => "$USER1$/check_memcache -H $HOSTNAME$"
end

nagios_command "nfs" do
  options "command_line" => "$USER1$/check_tcp -H $HOSTADDRESS$ -p 2049"
end

nagios_command "ntp" do
  options "command_line" => "$USER1$/check_ntp_peer -H $HOSTADDRESS$ -w1 -c 5 -t 20"
end

nagios_command "ntpd_time" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_ntpd_time -t 20"
end

nagios_command "proc_keepalived" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_proc_keepalived -t 20"
end

nagios_command "proc_ntpd" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_proc_ntpd -t 20"
end

nagios_command "sshd" do
  options "command_line" => "$USER1$/check_ssh $HOSTADDRESS$"
end

nagios_command "swap" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_swap -t 20"
end

nagios_command "tmpfs" do
  options "command_line" => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_tmpfs -t 20"
end

##  undefined local variable or method `iter' for cookbook: ref-monitoring, recipe: nagios_check_commands :Chef::Recipe
#nagios_command "check_resque_queue_#{iter}" do
  #options 'command_line' => "/usr/lib/nagios/plugins/check_resque_queue_#{iter}.rb -q $ARG1$ -w $ARG2$ -c $ARG3$"
#end

#nagios_command "rds_repl_delay" do
  #options "command_line" => "$USER1$/check_mysql -H $HOSTADDRESS$ -u nagios -p #{node['bp-nagios']['rds-slave']['mysql_password']} -S -w #{node['bp-nagios']['rds-slave']['warning']} -c #{node['bp-nagios']['rds-slave']['critical']}"
#end

##  CHECK_PROMETHEUS:
##    THE FIRST ELEMENT OF THE VECTOR IS USED FOR THE CHECK,
##    PRINTING THE EXTRA METRIC INFORMATION INTO THE NAGIOS MESSAGE
nagios_command 'check_prometheus_extra_info' do
  options 'command_line' => "$USER1$/check_prometheus_metric.sh -H '$ARG1$' -q '$ARG2$' -w '$ARG3$' -c '$ARG4$' -n '$ARG5$' -m '$ARG6$' -i -t vector"
end
