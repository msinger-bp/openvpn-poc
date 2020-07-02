
databases=%w{maindb}.map {|i| [i, {'dsn' => "mysql://#{node['dsn'][i]['username']}:#{node['dsn'][i]['password']}@#{node['dsn'][i]['endpoint']}/#{node['dsn'][i]['schema']}"}]}.to_h

metrics={'nexia_ee_active_thermostats'     => {"type" => "gauge", "description" => "Number of active thermostats"},
         'nexia_ee_subscribed_thermostats' => {"type" => "gauge", "description" => "Number of thermostats with EE subscription"},
         'nexia_ee_active_subscriptions'   => {"type" => "gauge", 
                                               "description" => "Count active subscriptions per device (per algorithm)", 
                                               "labels" => ['algorithm']},
         'nexia_ee_enabled_thermostats'    => {"type" => "gauge", 
                                               "description" => "Count thermostats with subscriptions and EE on",
                                               "labels" => ['algorithm', 'flavor', 'ee_enabled']},
         'nexia_ee_last_thermostat_event'  => {"type" => "gauge", "description" => "Date/time of most recent thermostat event"},
         'nexia_ee_online_thermostats'     => {"type" => "gauge", "description" => "Number of online thermostats"},
         'nexia_ee_supertable_delay'       => {"type" => "gauge", "description" => "Hours since last supertable complete"}
        }

queries={ 'nexia_ee_active_thermostats'     => {'interval'  => '60s', 
                                                'databases' => ['oltp'], 
                                                'metrics'   => ['nexia_ee_active_thermostats'], 
                                                'sql'       => 'select count(*) from ef_thermostat where `thermostat_model_id`=901 and thermostat_status="ACTIVE"'
                                               }, 
          'nexia_ee_subscribed_thermostats' => {'interval'  => '60s', 
                                                'databases' => ['oltp'], 
                                                'metrics'   => ['nexia_ee_subscribed_thermostats'], 
                                                'sql'       => 'select count(*) from `ef_thermostat` t join `ef_location` l on t.`location_id`=l.`location_id` join `ef_location_setting` ls on l.location_id = ls.`location_id` where t.thermostat_model_id=901 and t.`thermostat_status`="ACTIVE" and ee_level>0 and exists (select 1 from `ef_thermostat_algorithm_mapping` tam where tam.thermostat_id=t.thermostat_id and tam.`thermostat_algorithm_status`="ACTIVE")'
                                               },
          'nexia_ee_active_subscriptions'   => {'interval'  => '60s', 
                                                'databases' => ['oltp'], 
                                                'metrics'   => ['nexia_ee_active_subscriptions'], 
                                                'sql'       => 'SELECT algorithm_id AS algorithm, COUNT(*) AS nexia_ee_active_subscriptions FROM (SELECT thermostat_id, algorithm_id FROM ef_thermostat_algorithm WHERE thermostat_algorithm_status="ACTIVE" GROUP BY thermostat_id, algorithm_id) t GROUP BY algorithm_id'
                                               },
          'nexia_ee_enabled_thermostats'    => {'interval'  => '60s', 
                                                'databases' => ['oltp'], 
                                                'metrics'   => ['nexia_ee_enabled_thermostats'], 
                                                'sql'       => 'SELECT algorithm_id as algorithm, flavor_name as flavor, (CASE WHEN ee_level>0 THEN "On" ELSE "Off" END) AS ee_enabled, COUNT(*) AS nexia_ee_enabled_thermostats FROM ef_algorithm_flavor af JOIN ef_thermostat_algorithm_mapping tam USING (algorithm_flavor_id) JOIN ef_thermostat t USING (thermostat_id) JOIN ef_location_setting ls USING (location_id) WHERE thermostat_algorithm_status="ACTIVE" GROUP BY algorithm_id, algorithm_flavor_id, ee_enabled'
                                               },
          'nexia_ee_last_thermostat_event'  => {'interval'  => '300s', 
                                                'databases' => ['ts'], 
                                                'metrics'   => ['nexia_ee_last_thermostat_event'], 
                                                'sql'       => 'SELECT TIME_TO_SEC(TIMEDIFF(now(), (SELECT MAX(start_time) FROM efts.ef_thermostat_range_data_p)))'
                                               },
          'nexia_ee_online_thermostats'    => {'interval'  => '60s', 
                                                'databases' => ['ts'], 
                                                'metrics'   => ['nexia_ee_online_thermostats'], 
                                                'sql'       => 'SELECT COUNT(DISTINCT thermostat_id) AS online_thermostats FROM efts.ef_thermostat_range_data_p WHERE start_time > DATE_SUB(NOW(), INTERVAL 7200 SECOND)'
                                               },
          'nexia_ee_supertable_delay'       => {'interval'  => '300s', 
                                                'databases' => ['oltp'], 
                                                'metrics'   => ['nexia_ee_supertable_delay'], 
                                                'sql'       => 'SELECT TIMESTAMPDIFF(MINUTE, MAX(data_end), NOW())/60 AS nexia_ee_supertable_delay FROM quant_tracking.ef_supertable2_processed_ranges WHERE status="COMPLETE"'
                                               },
        }

query={ 'databases' => databases, 'metrics' => metrics, 'queries' => queries }

directory '/etc/query_exporter' do
  mode '0755'
  owner 'root'
  group 'root'
end

#/app/config.yml
file '/etc/query_exporter/config.yml' do
  content YAML::dump(query).to_s.gsub(/^---$/, '').strip
  owner   node[cookbook_name]['container']['user']
  group   node[cookbook_name]['container']['group']
  mode    '0644'
  notifies       :redeploy, 'docker_container[query_exporter]', :immediately
end

docker_image_prune 'query_exporter' do
  dangling false
  action :nothing
end

docker_image 'query_exporter' do
  repo           node[cookbook_name]['query-exporter']['repo']
  tag            node[cookbook_name]['query-exporter']['tag']
  action         :pull
  notifies       :redeploy, 'docker_container[query_exporter]', :immediately
  notifies       :prune, 'docker_image_prune[query_exporter]', :delayed
  ignore_failure true
end

docker_container 'query_exporter' do
  repo           node[cookbook_name]['query-exporter']['repo']
  tag            node[cookbook_name]['query-exporter']['tag']
  user           "#{node[cookbook_name]['container']['uid']}:#{node[cookbook_name]['container']['gid']}"
  restart_policy 'always'
  network_mode   'host'
  log_opts       [ 'max-size=10M', 'max-file=5' ]
  volumes        [ '/etc/query_exporter/config.yml:/app/config.yml' ]
  ro_rootfs      true
  cap_drop       [ 'CHOWN', 'DAC_OVERRIDE', 'FOWNER', 'MKNOD', 'SETGID', 'SETUID', 'SETFCAP', 'SETPCAP', 'NET_BIND_SERVICE', 'KILL' ]
  ignore_failure true
end


