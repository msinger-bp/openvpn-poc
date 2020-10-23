cookbook_file "/etc/adduser.conf" do
  source 'adduser.conf'
  owner  'root'
  group  'root'
  mode   0644
  action :create
end

users_manage 'sysadmin' do
  group_id 20000
  action :create
end

# Used for chef-robot, a member of nogroup
users_manage 'nogroup' do
  group_name nogroup
  action :create
end

sudo "sysadmin" do
  group "sysadmin"
  nopasswd true
  env_keep_add ['SSH_AUTH_SOCK']
end

