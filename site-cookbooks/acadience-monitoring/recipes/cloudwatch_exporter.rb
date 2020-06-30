cw={'region' => node['ec2']['region'], 
    'metrics' => [ {'aws_namespace' => 'AWS/RDS', 
                    'aws_metric_name' => 'FreeStorageSpace', 
                    'aws_dimensions' => ['DBInstanceIdentifier'],
                    'aws_dimension_select' => {
                      'DBInstanceIdentifier' => node['mysql_instance_ids'].to_a
                    },
                    'aws_statistics' => ['Average']
                   },
                   {'aws_namespace' => 'AWS/RDS', 
                    'aws_metric_name' => 'CPUUtilization', 
                    'aws_dimensions' => ['DBInstanceIdentifier'],
                    'aws_dimension_select' => {
                      'DBInstanceIdentifier' => node['mysql_instance_ids'].to_a
                    },
                    'aws_statistics' => ['Average']
                   },
                   {'aws_namespace' => 'AWS/ElastiCache', 
                    'aws_metric_name' => 'EngineCPUUtilization', 
                    'aws_dimensions' => ['CacheClusterId'],
                    'aws_dimension_select' => {
                      'CacheClusterId' => node['redis_instance_ids'].to_a
                    },
                    'aws_statistics' => ['Average']
                   },
                   {'aws_namespace' => 'AWS/ElastiCache', 
                    'aws_metric_name' => 'IsMaster', 
                    'aws_dimensions' => ['CacheClusterId'],
                    'aws_dimension_select' => {
                      'CacheClusterId' => node['redis_instance_ids'].to_a
                    },
                    'aws_statistics' => ['Average']
                   },
                   {'aws_namespace' => 'AWS/ElastiCache', 
                    'aws_metric_name' => 'CurrItems', 
                    'aws_dimensions' => ['CacheClusterId'],
                    'aws_dimension_select' => {
                      'CacheClusterId' => node['redis_instance_ids'].to_a
                    },
                    'aws_statistics' => ['Average']
                   },
                   {'aws_namespace' => 'AWS/ElastiCache', 
                    'aws_metric_name' => 'ReplicationLag', 
                    'aws_dimensions' => ['CacheClusterId'],
                    'aws_dimension_select' => {
                      'CacheClusterId' => node['redis_instance_ids'].to_a
                    },
                    'aws_statistics' => ['Average']
                   },
                   {'aws_namespace' => 'AWS/ElastiCache', 
                    'aws_metric_name' => 'Evictions', 
                    'aws_dimensions' => ['CacheClusterId'],
                    'aws_dimension_select' => {
                      'CacheClusterId' => node['redis_instance_ids'].to_a
                    },
                    'aws_statistics' => ['Average']
                   },
                   {'aws_namespace' => 'AWS/ElastiCache', 
                    'aws_metric_name' => 'FreeableMemory', 
                    'aws_dimensions' => ['CacheClusterId'],
                    'aws_dimension_select' => {
                      'CacheClusterId' => node['redis_instance_ids'].to_a
                    },
                     'aws_statistics' => ['Average']
                   }
                 ]
   }

directory '/etc/cloudwatch_exporter' do
  mode '0755'
  owner 'root'
  group 'root'
end

file '/etc/cloudwatch_exporter/config.yml' do
  content YAML::dump(cw.to_hash.compact).to_s.gsub(/^---$/, '').strip
  owner   node[cookbook_name]['container']['user']
  group   node[cookbook_name]['container']['group']
  mode    '0644'
  notifies :redeploy, 'docker_container[cloudwatch_exporter]', :immediately
end

docker_image_prune 'cloudwatch_exporter' do
  dangling false
  action :nothing
end

docker_image 'cloudwatch_exporter' do
  repo           node[cookbook_name]['cloudwatch-exporter']['repo']
  tag            node[cookbook_name]['cloudwatch-exporter']['tag']
  action         :pull
  notifies       :redeploy, 'docker_container[cloudwatch_exporter]', :immediately
  notifies       :prune, 'docker_image_prune[cloudwatch_exporter]', :delayed
  ignore_failure true
end

docker_container 'cloudwatch_exporter' do
  repo           node[cookbook_name]['cloudwatch-exporter']['repo']
  tag            node[cookbook_name]['cloudwatch-exporter']['tag']
  user           "#{node[cookbook_name]['container']['uid']}:#{node[cookbook_name]['container']['gid']}"
  restart_policy 'always'
  network_mode   'host'
  log_opts       [ 'max-size=10M', 'max-file=5' ]
  volumes        [ '/etc/cloudwatch_exporter/config.yml:/config/config.yml' ]
  ro_rootfs      true
  cap_drop       [ 'CHOWN', 'DAC_OVERRIDE', 'FOWNER', 'MKNOD', 'SETGID', 'SETUID', 'SETFCAP', 'SETPCAP', 'NET_BIND_SERVICE', 'KILL' ]
  ignore_failure true
end
