
# Used for chef-robot, a member of nogroup
# For now, this will create EVERY user in "nogroup".
# (For the moment, there is only one user there anyways...
#  ...but I want a cleaner solution for the future.)
users_manage 'nogroup' do
  group_name 'nogroup'
  action :create
end

# Add authorized_keys file for chef-robot that can ONLY run the "run-chef-on-all-frontend-nodes-in-this-environment.sh" command.
cookbook_file "/home/chef-robot/.ssh/authorized_keys" do
  source "authorized_keys"
  owner  'chef-robot'
  group  'nogroup'
  mode   0600
  action :create
end

# Add the command that... runs chef on all frontend nodes in this environment.
# This script does two different things. If run on a bastion host, it SSHes into
# frontend hosts and runs itself. But if run on a frontend host, it actually runs
# sudo chef-client.

cookbook_file "/home/chef-robot/run-chef-on-all-frontend-nodes-in-this-environment.sh" do
  source "run-chef-on-all-frontend-nodes-in-this-environment.sh"
  owner  'chef-robot'
  group  'nogroup'
  mode   0544
  action :create
end

if node.run_list.roles.include?('bastion')
  # Bastion host needs the ability to run "sudo git pull".
  cookbook_file "/etc/sudoers.d/chef-robot-bastion"
    source "chef-robot-bastion"
    owner  'root'
    group  'root'
    mode   0440
    action :create
  end
end


