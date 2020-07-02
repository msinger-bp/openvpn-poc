# site-cookbooks/nexia-prometheus/recipes/nagios.rb
# last edit 2020 Jan 09

#----------
# basic checks

nagios_command "check_all_disks" do
  options "command_line"        => "$USER1$/check_nrpe -H $HOSTADDRESS$ -c check_all_disks"
end

nagios_service 'linux_check_all_disks' do
  options 'use'                 => 'default-service',
          'description'         => 'Check All Disks',
          'service_template'    => 'default-service',
          'check_command'       => 'check_all_disks',
          'hostgroup_name'      => 'linux'
end

#---------
# disk space checks for nodes with secondary volumes

all_nodes=search(:node, '*:*')

ms=all_nodes.select {|i| node['terraform'][node.chef_environment]['modules'][0]['outputs']['all_instances']['value'].include?(i['fqdn']) && i['filesystem']['by_mountpoint'].key?('/srv')}.map{|i| i['name']}.join(',')

nagios_hostgroup 'disk-/srv' do
  options 'alias' => 'instances which have /srv mounted',
          'members' => ms
end

nagios_command 'check-predictive-disk-hours-until-full' do
  options "command_line" => "$USER1$/negate --unknown=OK $USER1$/check_prometheus_metric.sh -H http://#{node['acadience-monitoring']['prometheus_endpoint']}:9090 -q 'filesystem:filesystem_time_until_zero_free_hours:ratio_deriv1h{instance=~\"$HOSTNAME$.*\",mountpoint=\"$ARG1$\"} > 0' -n '$ARG1$ predictive free hours' -O -m le -t vector -w $ARG2$ -c $ARG3$"
end

nagios_service "check-predictive-disk-hours-until-full-/" do
  options 'use'                   => 'default-service',
          'description'           => 'check number of hours until disk fills up',
          'service_template'      => 'default-service',
          'check_command'         => 'check-predictive-disk-hours-until-full!/!240!6',
          'hostgroup_name'        => 'linux',
          'notes_url'             => 'https://mwiki.bitpusher.com/index.php/Nexia_Runbook#check-predictive-disk-hours-until-full'
end
 
nagios_service "check-predictive-disk-hours-until-full-/srv-10day" do
  options 'use'                   => 'default-service',
          'description'           => 'check number of hours until disk fills up',
          'service_template'      => 'default-service',
          'check_command'         => 'check-predictive-disk-hours-until-full!/srv!240!6',
          'hostgroup_name'        => 'disk-/srv',
          'notes_url'             => 'https://mwiki.bitpusher.com/index.php/Nexia_Runbook#check-predictive-disk-hours-until-full'
end
 
nagios_command 'check-cpu-average' do
  options "command_line" => "$USER1$/check_prometheus_metric.sh -H http://localhost:9090 -q 'cpu:cpu_utilization:percent_avg$ARG1${instance=~\"$HOSTNAME$.*\"}' -n 'CPU usage $ARG1$ average' -O -m ge -t vector -w $ARG2$ -c $ARG3$"
end

nagios_service "check-cpu-average-15m" do
  options 'use'                  => 'default-service',
          'description'          => 'check 15m cpu average',
          'service_template'     => 'default-service',
          'check_command'        => 'check-cpu-average!15m!90!93',
          'hostgroup_name'       => 'linux',
          'contact_groups'       => 'admins-email-only'
end
  
nagios_service "check-cpu-average-5m" do
  options 'use'                 => 'default-service',
          'description'         => 'check 5m cpu average',
          'service_template'    => 'default-service',
          'check_command'       => 'check-cpu-average!5m!80!95',
          'hostgroup_name'      => 'linux'
end
  
nagios_service "check-cpu-average-1m" do
  options 'use'                 => 'default-service',
          'description'         => 'check 1m cpu average',
          'service_template'    => 'default-service',
          'check_command'       => 'check-cpu-average!1m!90!99',
          'hostgroup_name'      => 'linux'
end

nagios_command 'check-dummy' do
  options 'command_line'        => "$USER1$/check_dummy 0 'dummy check'"
end

nagios_hostgroup 'service-only-hosts' do
  options 'alias' => 'addresses for service check'
end

# this will be a template (register 0) host
# I believe that adding a 'name' option forces this host declaration to be a template
nagios_host 'service-only-host' do
  options 'name'                 => 'service-only-host',
          'use'                  => 'default-host',
          'check_command'        => 'check-dummy',
          'max_check_attempts'   => '1',
          'contacts'             => 'bitpusher-warning-email',
          'notification_options' => 'n'
end

#----------
# prometheus host and query checks
#   'prometheus-checks' is a nagios host that is used for prometheus query checks, partially to group the checks in
#   a categorizable way and partly to allow changing of the endpoint in the future

nagios_host 'prometheus-checks' do
  options 'use'                  => 'service-only-host',
          'address'              => node['acadience-monitoring']['prometheus_endpoint'],
          'hostgroup_name'       => 'service-only-hosts'
end

#---------
# redis checks

nagios_hostgroup 'redis-instances' do
  options 'alias' => 'redis-instances'
end

nagios_command 'check-elasticache-engine-cpu-utilization' do
  options "command_line" => "$USER1$/check_prometheus_metric.sh -H http://#{node['acadience-monitoring']['prometheus_endpoint']}:9090 -q 'aws_elasticache_engine_cpuutilization_average{cache_cluster_id=\"$HOSTNAME$\"} offset 10m' -n '$HOSTNAME$ % Average CPU Utilization' -O -m ge -t vector -w $ARG1$ -c $ARG2$"
end

nagios_service "check-elasticache-engine-cpu-utilization" do
  options 'use'                 => 'default-service',
          'description'         => "Average CPU Utilization",
          'service_template'    => 'default-service',
          'check_command'       => "check-elasticache-engine-cpu-utilization!85!90",
          'hostgroup_name'      => 'redis-instances'
end

nagios_command 'check-elasticache-freeable-memory' do
  options "command_line" => "$USER1$/check_prometheus_metric.sh -H http://#{node['acadience-monitoring']['prometheus_endpoint']}:9090 -q 'aws_elasticache_freeable_memory_average{cache_cluster_id=\"$HOSTNAME$\"} offset 10m / (1000 * 1000)' -n '$HOSTNAME$ Freeable Memory (MB)' -O -m lt -t vector -w $ARG1$ -c $ARG2$"
end

nagios_service "check-elasticache-freeable-memory" do
  options 'use'                 => 'default-service',
          'description'         => "Freeable Memory (MB)",
          'check_command'       => "check-elasticache-freeable-memory!1500!500",
          'hostgroup_name'      => 'redis-instances'
end

node['redis_instance_ids'].each do |ec|
  nagios_host "#{ec}" do
    options 'use'                 => 'service-only-host',
            'address'             => '127.0.0.1',
            'hostgroups'          => [ 'redis-instances' ]
  end
end

#---------
# RDS checks

nagios_hostgroup 'mysql-rds-endpoints' do
  options 'alias' => 'mysql-rds-endpoints'
end

nagios_command "check-mysql-connectivity" do
  options "command_line"        => "$USER1$/check_mysql -n -H $HOSTADDRESS$"
end

nagios_service 'check-mysql-rds' do
  options 'use'                 => 'default-service',
          'description'         => 'check-mysql-rds',
          'check_command'       => 'check-mysql-connectivity',
          'hostgroup_name'      => 'mysql-rds-endpoints'
end

nagios_command 'check-rds-free-storage' do
  options "command_line" => "$USER1$/check_prometheus_metric.sh -H http://#{node['acadience-monitoring']['prometheus_endpoint']}:9090 -q 'aws_rds_free_storage_space_average{dbinstance_identifier=\"$HOSTNAME$\"} offset 10m / (1000*1000*1000)' -n '$HOSTNAME$ RDS Free Storage Space (GB)' -O -m lt -t vector -w $ARG1$ -c $ARG2$"
end

nagios_service "check-rds-free-storage" do
  options 'use'                 => 'default-service',
          'description'         => "RDS Free Storage Space (GB)",
          'check_command'       => "check-rds-free-storage!12!8",
          'hostgroup_name'      => 'mysql-rds-endpoints'
end

node['mysql_instance_ids'].each do |rds|
  nagios_host "#{rds}" do
    options 'use'                 => 'service-only-host',
            'address'             => "#{rds}.#{node['acadience-monitoring']['internal_domain']}",
            'hostgroups'          => [ 'mysql-rds-endpoints' ]
  end
end

nagios_command 'service_notify_by_email_with_from_address' do
  options 'command_line'        => '/usr/bin/printf "%b" "$LONGDATETIME$ - $SERVICEDESC$ $SERVICESTATE$\n\n$HOSTALIAS$  $NOTIFICATIONTYPE$\n\n$SERVICEOUTPUT$\n\nLogin: ssh://$HOSTNAME$" | /usr/bin/mail -r nagios@bitpusher.com -s "** (' + node['environment_name'] + ') $NOTIFICATIONTYPE$ - $HOSTALIAS$ - $SERVICEDESC$ - $SERVICESTATE$" $CONTACTEMAIL$'
end

nagios_command 'host_notify_by_email_with_from_address' do
  options 'command_line'        => '/usr/bin/printf "%b" "$LONGDATETIME$ - $SERVICEDESC$ $SERVICESTATE$\n\n$HOSTALIAS$  $NOTIFICATIONTYPE$\n\n$SERVICEOUTPUT$\n\nLogin: ssh://$HOSTNAME$" | /usr/bin/mail -r nagios@bitpusher.com -s "** (' + node['environment_name'] + ') $NOTIFICATIONTYPE$ - $HOSTALIAS$ - $SERVICEDESC$ - $SERVICESTATE$" $CONTACTEMAIL$'
end

nagios_command 'service_notify_by_email_not_default' do
  options 'command_line'        => '/usr/bin/printf "%b" "$LONGDATETIME$ - $SERVICEDESC$ $SERVICESTATE$\n\n$HOSTALIAS$  $NOTIFICATIONTYPE$\n\n$SERVICEOUTPUT$\n\nLogin: ssh://$HOSTNAME$" | /usr/bin/mail -s "** $NOTIFICATIONTYPE$ - $HOSTALIAS$ - $SERVICEDESC$ - $SERVICESTATE$" $CONTACTEMAIL$'
end

nagios_command 'host_notify_by_email_not_default' do
  options 'command_line'        => '/usr/bin/printf "%b" "$LONGDATETIME$ - $SERVICEDESC$ $SERVICESTATE$\n\n$HOSTALIAS$  $NOTIFICATIONTYPE$\n\n$SERVICEOUTPUT$\n\nLogin: ssh://$HOSTNAME$" | /usr/bin/mail -s "** $NOTIFICATIONTYPE$ - $HOSTALIAS$ - $SERVICEDESC$ - $SERVICESTATE$" $CONTACTEMAIL$'
end

nagios_contact 'bitpusher-critical-email' do
  options 'use'                           => 'default-contact',
          'contactgroups'                 => [ 'admins', 'admins-email-only' ],
          'host_notification_options'     => 'd,u,r',
          'host_notification_commands'    => 'host_notify_by_email_not_default',
          'service_notification_options'  => 'u,c,r',
          'service_notification_commands' => 'service_notify_by_email_not_default',
          'email'                         => node['acadience-monitoring']['critical_email']
end

nagios_contact 'bitpusher-warning-email' do
  options 'use'                           => 'default-contact',
          'contactgroups'                 => [ 'admins', 'admins-email-only' ],
          'host_notification_options'     => 'n',
          'host_notification_commands'    => 'host_notify_by_email_not_default',
          'service_notification_options'  => 'w',
          'service_notification_commands' => 'service_notify_by_email_not_default',
          'email'                         => node['acadience-monitoring']['warning_email']
end

# This must be done last
include_recipe "nagios::default"
include_recipe "nagios::pagerduty"

