
# Used for chef-robot, a member of nogroup
# For now, this will create EVERY user in "nogroup".
# (For the moment, there is only one user there anyways...
#  ...but I want a cleaner solution for the future.)
users_manage 'nogroup' do
  group_name 'nogroup'
  action :create
end



cookbook_file "/home/chef-robot/run-chef-on-all-frontend-nodes-in-this-environment.sh" do
  source "run-chef-on-all-frontend-nodes-in-this-environment.sh"
  owner  'chef-robot'
  group  'nogroup'
  mode   0544
  action :create
end

