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
include_recipe "#{cookbook_name}::users"

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

#environment used by app
env=[ "NODE_ENV=production", 
      "TEST_DATABASE_NAME=#{node['db']['name']}", 
      "DATABASE_NAME=#{node['db']['name']}", 
      "DATABASE_HOST=#{node['db']['host'].split(':').first}", 
      "DATABASE_USER=#{node['db']['username']}", 
      "DATABASE_PASSWORD=#{node['db']['password']}", 
      "SESSION_SECRET=foobarqwedfjkbdawdfjknawerjfkweFLEJKWFNjwefn132roinqedjdn",
      node[cookbook_name]['env'].map {|k,v| "#{k}=#{v}"}
      ].flatten

docker_image_prune 'frontend' do
  dangling false
  action :nothing
end

#When we get a new docker_image, we first stop all the running containers, then 
#run a new container to run "npm run migrate", then we relaunch all the app containers.
if node['env_flags']['auto_migrate'] == true
  env_list=(env + ["PORT=8000"]).map {|i| "--env #{i}"}.join(' ')
  bash 'run-migrations' do
    code <<-EOF
docker run -t - -rm #{env_list} -w /app/server #{node[cookbook_name]['repo']}:#{node[cookbook_name]['tag']} npm run migrate
docker container     prune -f
EOF
    action :nothing
  end
else #no migrate
  bash 'run-migrations' do
    code 'true'
    action :nothing
  end
end

docker_image 'frontend' do
  repo           node[cookbook_name]['repo']
  tag            node[cookbook_name]['tag']
  action         :pull
  notifies       :run,   'ruby_block[stop-containers]',  :immediately
  notifies       :run,   'bash[run-migrations]',         :immediately
  notifies       :prune, 'docker_image_prune[frontend]', :delayed
  ignore_failure true
end

(1..4).each do |i|
  c_env=env + ["PORT=#{8080 + i - 1}"]
  docker_container "frontend-#{i}" do
    repo           node[cookbook_name]['repo']
    tag            node[cookbook_name]['tag']
    user           "#{node[cookbook_name]['container']['uid']}:#{node[cookbook_name]['container']['gid']}"
    restart_policy 'always'
    network_mode   'host'
    env            c_env
    log_opts       [ 'max-size=10M', 'max-file=5' ]
    volumes        [ '/srv/acadience/frontend/config:/config', '/srv/acadience/frontend/data:/data', '/srv/acadience/frontend/tmp:/tmp' ]
    ro_rootfs      true
    cap_drop       [ 'CHOWN', 'DAC_OVERRIDE', 'FOWNER', 'MKNOD', 'SETGID', 'SETUID', 'SETFCAP', 'SETPCAP', 'NET_BIND_SERVICE', 'KILL' ]
    ignore_failure true
    subscribes :stop, 'ruby_block[stop-containers]', :immediately
    subscribes :redeploy, 'bash[run-migrations]', :immediately
  end
end

ruby_block 'stop-containers' do
  action :nothing
  block do
    "" #this is to make Ruby happy, does this make motz true?
  end
end
