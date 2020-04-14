##  CHECK_MULTI PLUGIN
package 'nagios-plugin-check-multi'
directory "#{node['nagios']['config_dir']}/check_multi" do
  owner node['nagios']['user']
  group node['nagios']['group']
end
cookbook_file 'nagioscheck.py' do
  path  '/usr/local/lib/python2.7/dist-packages/nagioscheck.py'
  mode  0644
  owner 'root'
  group 'root'
  action :create
  source 'nagioscheck.py'
end


##  ELASTICSEARCH/REDIS/MEMCACHE

cookbook_file "#{node['nagios']['config_dir']}/check_multi/elasticsearch.cmd" do
  mode '0644'
  owner 'nagios'
  group 'nagios'
  action :create
  source 'elasticsearch.cmd'
end

%w{check_es_cluster_status.py check_es_jvm_usage.py check_es_nodes.py check_es_split_brain.py check_es_unassigned_shards.py}.each do |file|
  cookbook_file file do
    path "#{node['nagios']['plugin_dir']}/#{file}"
    mode '0755'
    owner 'root'
    group 'root'
    action :create
    source file
  end
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

package 'python-memcache'
cookbook_file 'check_memcache' do
  path "#{node['nagios']['plugin_dir']}/check_memcache"
  mode '0755'
  owner 'root'
  group 'root'
  action :create
  source 'check_memcache'
end

