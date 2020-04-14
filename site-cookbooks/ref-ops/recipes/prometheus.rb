include_recipe 'prometheus::install_prometheus'
include_recipe 'prometheus::install_pushgateway'
include_recipe 'prometheus::configure_prometheus'
include_recipe "prometheus_clients::node_exporter"

#instances=[]
#node['terraform'][node.chef_environment]['modules'].each do |m|
#  if m.key?('outputs')
#    o=m['outputs']
#    if o.key?('internal_cnames') && o.key?('instance_ids') #assuming this is an actual instance we care to monitor.  don't know of a better way(yet)
#      instances << o['internal_cnames']['value']
#    end
#  end
#end
#instances.flatten!.sort!
instances=[node['terraform'][node.chef_environment]['modules'][0]['outputs']['monitored_instances']['value']].flatten.sort

prometheus_job "node_exporter" do
  target instances.map{|i| "#{i}:9100"}
  action :create
end

#docker_instances=[
#  node['kafka_instances'],
#  node['zookeeper_instances'],
#  node['storm_instances'],
#  node['jboss_instances'],
#  node['quant_instances'],
#  node['nossl_instances']
#]
#docker_instances.flatten!.sort!
#docker_instances=[node['terraform'][node.chef_environment]['modules'][0]['outputs']['docker_instances']['value']].flatten.sort

#prometheus_job "docker" do
  #target docker_instances.map{|i| "#{i}:9323"}
  #action :create
#end

prometheus_job "graphite_exporter" do
  target ["localhost:9108"]
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

#prometheus_record 'node:node_filesystem_remaining_hours:5m' do
#  group_name 'node'
#  expression '-(node_filesystem_free / deriv(node_filesystem_free[5m]))/3600'
#  action     :create
#end

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


##  PROMETHEUS CLOUDWATCH EXPORTER
##  BY ACUTCHIN, 2019-10-23

##  INSTALL PROMETHEUS CLOUDWATCH EXPORTER AND BUILD WITH MAVEN?
#openjdk-8-jdk-headless
#maven

directory '/opt/cloudwatch-exporter' do
  owner 'root'
  group 'root'
  mode  '0755'
end

#/opt/cloudwatch-exporter/config.yml
template "/opt/cloudwatch-exporter/config.yml" do
  source "prometheus.cw.exporter.config.yml.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  #notifies :restart, 'docker_container[quant]', :delayed
end

prometheus_job "cloudwatch_exporter" do
  target ["localhost:2020"]
  action :create
end

