# This code will create a robot user, and ensure that
# its group exists if it doesn't already.
#
# The default['chef-robot']['robot'][FOO] stuff is defined in
# attributes/default.rb.
#
# This code is based on a similar pattern found in:
# acadience-infra/site-cookbooks/acadience-frontend/default.rb

group node[cookbook_name]['robot']['group'] do
  gid    node[cookbook_name]['robot']['gid']
  system true
  action :create
end

user node[cookbook_name]['robot']['user'] do
  uid     node[cookbook_name]['robot']['uid']
  gid     node[cookbook_name]['robot']['gid']
  home    node[cookbook_name]['robot']['home']
  manage_home true
  comment "Chef-Robot user created by chef-robot Chef cookbook"
  system  true
  action  :create
end

directory node[cookbook_name]['robot']['ssh_dir'] do
  owner node[cookbook_name]['robot']['user']
  group node[cookbook_name]['robot']['group']
  mode   0600
  action :create
  recursive true
end

