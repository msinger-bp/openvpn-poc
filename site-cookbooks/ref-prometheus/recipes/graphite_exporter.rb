directory '/etc/docker' do
  owner 'root'
  group 'root'
  mode  '0755'
end

file '/etc/docker/daemon.json' do
  owner 'root'
  group 'root'
  mode  '0644'
  content "{\"metrics-addr\":\"#{node['ipaddress']}:9323\",\"experimental\":true}"
end

docker_installation 'default'

graphite={}
graphite['mappings']=[]
graphite['mappings'][0]={}
graphite['mappings'][0]['match']                    ='storm.metrics.prod.ref_processor.*.*.count'
graphite['mappings'][0]['name']                     ='ref_processor'
graphite['mappings'][0]['timer_type']               ='summary'
graphite['mappings'][0]['labels']                   ={}
graphite['mappings'][0]['labels']['kinesis_events'] ='$1'
graphite['mappings'][0]['labels']['metric']         ='$2'

directory '/etc/graphite_exporter' do
  mode '0755'
  owner 'root'
  group 'root'
end

file '/etc/graphite_exporter/mappings.conf' do
  content YAML::dump(graphite.to_hash.compact).to_s.gsub(/^---$/, '').strip
  owner   node[cookbook_name]['container']['user']
  group   node[cookbook_name]['container']['group']
  mode    '0644'
end

docker_image_prune 'graphite_exporter' do
  dangling false
  action :nothing
end

docker_image 'graphite_exporter' do
  repo           node[cookbook_name]['repo']
  tag            node[cookbook_name]['tag']
  action         :pull
  notifies       :redeploy, 'docker_container[graphite_exporter]', :immediately
  notifies       :prune, 'docker_image_prune[graphite_exporter]', :delayed
  ignore_failure true
end

docker_container 'graphite_exporter' do
  command        "--graphite.mapping-config=/tmp/mappings.conf" #uses silly ENTRYPOINT hack
  repo           node[cookbook_name]['repo']
  tag            node[cookbook_name]['tag']
  user           "#{node[cookbook_name]['container']['uid']}:#{node[cookbook_name]['container']['gid']}"
  restart_policy 'always'
  network_mode   'host'
  log_opts       [ 'max-size=10M', 'max-file=5' ]
  volumes        [ '/etc/graphite_exporter/mappings.conf:/tmp/mappings.conf' ]
  ro_rootfs      true
  cap_drop       [ 'CHOWN', 'DAC_OVERRIDE', 'FOWNER', 'MKNOD', 'SETGID', 'SETUID', 'SETFCAP', 'SETPCAP', 'NET_BIND_SERVICE', 'KILL' ]
  ignore_failure true
end

#prometheus_job "graphite_exporter" do
#  target ["localhost:9108"]
#  action :create
#end

