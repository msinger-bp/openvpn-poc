
# Used for chef-robot, a member of nogroup
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

