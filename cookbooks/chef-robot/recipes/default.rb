# This code will create a robot user, and ensure that
# its group exists if it doesn't already.
#
# Define the following parameters in attributes/default.rb:
# default['chef-robot']['robot']['user']
# default['chef-robot']['robot']['uid']
# default['chef-robot']['robot']['group']
# default['chef-robot']['robot']['gid']
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
  comment "Chef-Robot user created by chef-robot Chef cookbook"
  system  true
  action  :create
end
