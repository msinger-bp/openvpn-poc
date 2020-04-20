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

# needs to happen after docker is installed...
include_recipe "#{cookbook_name}::ecr_auth"

# all container should run as this user
group node[cookbook_name]['container']['group'] do
  gid    node[cookbook_name]['container']['gid']
  system true
  action :create
end

user node[cookbook_name]['container']['user'] do
  uid     node[cookbook_name]['container']['uid']
  gid     node[cookbook_name]['container']['gid']
  comment "Container User"
  system  true
  action  :create
end

directory "/srv/acadience" do
  owner  "root"
  group  "root"
  mode   "0755"
  action :create
end

directory "/srv/acadience/frontend" do
  owner  "root"
  group  "root"
  mode   "0755"
  action :create
end

directory "/srv/acadience/frontend/config" do
  owner  "root"
  group  "root"
  mode   "0755"
  action :create
end

directory "/srv/acadience/frontend/data" do
  owner  node[cookbook_name]['container']['user']
  group  node[cookbook_name]['container']['group']
  mode   "0755"
  action :create
end

directory "/srv/acadience/frontend/tmp" do
  owner  node[cookbook_name]['container']['user']
  group  node[cookbook_name]['container']['group']
  mode   "0755"
  action :create
end

docker_image_prune 'frontend' do
  dangling false
  action :nothing
end

docker_image 'frontend' do
  repo           node[cookbook_name]['repo']
  tag            node[cookbook_name]['tag']
  action         :pull
  notifies       :redeploy, 'docker_container[frontend]', :immediately
  notifies       :prune, 'docker_image_prune[frontend]', :delayed
  ignore_failure true
end

docker_container 'frontend' do
  repo           node[cookbook_name]['repo']
  tag            node[cookbook_name]['tag']
  user           "#{node[cookbook_name]['container']['uid']}:#{node[cookbook_name]['container']['gid']}"
  restart_policy 'always'
  network_mode   'host'
  env            [ "DATABASE_NAME=app", "DATABASE_HOST=#{node['db']['host']}", "DATABASE_USER=#{node['db']['username']}", "DATABASE_PASSWORD=#{node['db']['password']}", "SESSION_SECRET=foobar" ]
  log_opts       [ 'max-size=10M', 'max-file=5' ]
  volumes        [ '/srv/acadience/frontend/config:/config', '/srv/acadience/frontend/data:/data', '/srv/acadience/frontend/tmp:/tmp' ]
  ro_rootfs      true
  cap_drop       [ 'CHOWN', 'DAC_OVERRIDE', 'FOWNER', 'MKNOD', 'SETGID', 'SETUID', 'SETFCAP', 'SETPCAP', 'NET_BIND_SERVICE', 'KILL' ]
  ignore_failure true
end

