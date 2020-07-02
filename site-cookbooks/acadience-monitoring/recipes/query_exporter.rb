
databases=%w{maindb}.map {|i| [i, {'dsn' => "mysql://#{node['dsn'][i]['username']}:#{node['dsn'][i]['password']}@#{node['dsn'][i]['endpoint']}/#{node['dsn'][i]['schema']}"}]}.to_h

metrics={'sftp_unfinished_jobs'             => {"type" => "gauge", "description" => "Number of unfinished SFTP ingestion jobs"},
        }

queries={ 'sftp_unfinished_jobs'            => {'interval'  => '60s', 
                                                'databases' => ['maindb'], 
                                                'metrics'   => ['sftp_unfinished_jobs'], 
                                                'sql'       => 'SELECT COUNT(*) FROM import_jobs WHERE upload_success is NULL'
                                               }
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


