# This code will create a robot user, and ensure that
# its group exists if it doesn't already.
#
# Define the following parameters in attributes/default.rb:
# default['chef-robot']['robot-user']['user']
# default['chef-robot']['robot-user']['uid']
# default['chef-robot']['robot-user']['group']
# default['chef-robot']['robot-user']['gid']
#
# This code is based on a similar pattern found in:
# acadience-infra/site-cookbooks/acadience-frontend/default.rb

group node[cookbook_name]['robot-user']['group'] do
  gid    node[cookbook_name]['robot-user']['gid']
  system true
  action :create
end

user node[cookbook_name]['robot-user']['user'] do
  uid     node[cookbook_name]['robot-user']['uid']
  gid     node[cookbook_name]['robot-user']['gid']
  comment "Chef-Robot user created by chef-robot Chef cookbook"
  system  true
  action  :create
end
