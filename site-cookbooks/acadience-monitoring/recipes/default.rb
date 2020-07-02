%w(prometheus::install_prometheus
   prometheus::install_pushgateway
   prometheus::configure_prometheus
   ).each do |i|
  include_recipe i
end

include_recipe "#{cookbook_name}::cloudwatch_exporter"
include_recipe "#{cookbook_name}::nagios"

cookbook_file '/usr/lib/nagios/plugins/check_prometheus_metric.sh' do
  source 'check_prometheus_metric.sh'
  owner 'root'
  group 'root'
  mode  '0755'
end

directory "/var/lib/prometheus/node-exporter" do
  owner 'root'
  group 'root'
  mode  '0755'
end

# check_prometheus needs jq
package 'jq'

instances=[node['terraform'][node.chef_environment]['modules'][0]['outputs']['monitored_instances']['value']].flatten.sort

prometheus_job "node_exporter" do
  target instances.map{|i| "#{i}:9100"}
  action :create
end

docker_instances=[node['terraform'][node.chef_environment]['modules'][0]['outputs']['docker_instances']['value']].flatten.sort

prometheus_job "docker" do
  target docker_instances.map{|i| "#{i}:9323"}
  action :create
end

include_recipe "#{cookbook_name}::mysqld_exporter" # for RDS servers
mysqld_nodes=node['rds_prom_targets']
prometheus_job "mysqld_exporter" do
  target mysqld_nodes.map{|i| "#{i}:9104"}
  action :create
end

prometheus_job "cloudwatch_exporter" do
  target ["localhost:9106"]
  action :create
end

prometheus_job "query_exporter" do
  target ["localhost:9560"]
  action :create
end

prometheus_alert "LowDiskSpace" do
  group_name  "node"
  expression  'node_filesystem_avail{fstype=~"(ext.|xfs)",job="node"} / node_filesystem_size{fstype=~"(ext.|xfs)",job="node"} * 100 <= 15'
  for_time    '15m'
  labels      ({'severity'    => 'warning'})
  annotations ({'title'       => 'Less than 15% disk space left',
                'description' => 'There\'s only 15% disk space left',
                'value'       => '{{ $value | humanize }}%',
                'device'      => '{{ $labels.device }}%',
                'mount_point' => '{{ $labels.mountpoint }}%'})
  action :create
end

prometheus_alert "CriticalDiskSpace" do
  group_name  "node"
  expression  'node_filesystem_avail{fstype=~"(ext.|xfs)",job="node"} / node_filesystem_size{fstype=~"(ext.|xfs)",job="node"} * 100 <= 10'
  for_time    '15m'
  labels      ({'severity'    => 'critical',
               'pager'        => 'pagerduty'})
  annotations ({'title'       => 'Less than 10% disk space left',
                'description' => 'There\'s only 10% disk space left',
                'value'       => '{{ $value | humanize }}%',
                'device'      => '{{ $labels.device }}%',
                'mount_point' => '{{ $labels.mountpoint }}%'})
  action :create
end

prometheus_alert "PredictiveDiskSpace(72h)" do
  group_name  "node"
  expression  'node:node_filesystem_free:predict_full_72h < 0'
  for_time    '15m'
  labels      ({'severity'    => 'warning'})
  annotations ({'title'       => 'Predict disk full in 72 hours',
                'description' => 'Predict disk full in 72 hours',
                'device'      => '{{ $labels.device }}%',
                'mount_point' => '{{ $labels.mountpoint }}%'})
  action :create
end

prometheus_alert "PredictiveDiskSpace(12h)" do
  group_name  "node"
  expression  'node:node_filesystem_free:predict_full_12h < 0'
  for_time    '5m'
  labels      ({'severity'    => 'critical',
                'pager'       => 'pagerduty'})
  annotations ({'title'       => 'Predict disk full in 12 hours',
                'description' => 'Predict disk full in 12 hours',
                'device'      => '{{ $labels.device }}%',
                'mount_point' => '{{ $labels.mountpoint }}%'})
  action :create
end

prometheus_record 'node:node_filesystem_free:predict_full_72h' do
  group_name 'node'
  expression 'predict_linear(node_filesystem_free{job="node"}[1h], 72 * 3600)'
  action     :create
end

prometheus_record 'node:node_filesystem_free:predict_full_12h' do
  group_name 'node'
  expression 'predict_linear(node_filesystem_free{job="node"}[5m], 12 * 3600)'
  action     :create
end

prometheus_record 'node:node_filesystem_percent_free:percent' do
  group_name 'node'
  expression 'node_filesystem_avail{fstype=~"(ext.|xfs)"} / node_filesystem_size{fstype=~"(ext.|xfs)"} * 100'
  action     :create
end

# Catch fast growth(like corefiles being dumped)
prometheus_record 'filesystem:filesystem_time_until_zero_free_hours:ratio_deriv1h' do
  group_name 'node'
  expression '-(node_filesystem_free / deriv(node_filesystem_free[1h]))/3600'
  action     :create
end

# Catch slow growth(like missing logrotate)
prometheus_record 'filesystem:filesystem_time_until_zero_free_days:ratio_deriv1w' do
  group_name 'node'
  expression '-(node_filesystem_free / deriv(node_filesystem_free[1w]))/(3600*24)'
  action     :create
end

#Match the loadavg timebases (though poll frequency makes 1m questionable)
prometheus_record 'cpu:cpu_utilization:percent_avg1m' do
  group_name 'node'
  expression '100 * (1 - avg by(instance)(irate(node_cpu{mode="idle"}[1m])))'
  action :create
end

prometheus_record 'cpu:cpu_utilization:percent_avg5m' do
  group_name 'node'
  expression '100 * (1 - avg by(instance)(irate(node_cpu{mode="idle"}[5m])))'
  action :create
end

prometheus_record 'cpu:cpu_utilization:percent_avg15m' do
  group_name 'node'
  expression '100 * (1 - avg by(instance)(irate(node_cpu{mode="idle"}[15m])))'
  action :create
end

# These should really go into a "base" cookbook
prometheus_threshold 'filesystem:filesystem_time_until_zero_free_days:ratio_deriv1w' do
  values({{'device' => '/dev/xvda1', 'mountpoint' => '/'} => 42})
  action :create
end

prometheus_threshold 'filesystem:filesystem_time_until_zero_free_days:ratio_deriv1w' do
  values({{'device' => '/dev/xvdb', 'mountpoint' => '/tmp'} => 24})
  action :create
end

prometheus_threshold 'filesystem:filesystem_time_until_zero_free_days:ratio_deriv1w' do
  values({{'device' => '/dev/xvda1', 'mountpoint' => '/'} => 420})
  action :create
end


prometheus_record 'mysql_slave_lag_seconds' do
  group_name 'mysqld'
  expression 'mysql_slave_status_seconds_behind_master - mysql_slave_status_sql_delay'
  action     :create
end

prometheus_record 'job:mysql_transactions:rate5m' do
  group_name 'mysqld'
  expression 'sum(rate(mysql_global_status_commands_total{command=~"(commit|rollback)"}[5m])) WITHOUT (command)'
  action     :create
end

include_recipe "#{cookbook_name}::grafana"
 
