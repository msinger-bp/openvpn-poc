include_recipe "chef-robot"
# i.e., include the default recipe, chef-robot::default
# This ensures the chef-robot user actually exists! ;-)


# Add authorized_keys file for chef-robot that can ONLY run the "run-chef-on-all-frontend-nodes-in-this-environment.sh" command.
cookbook_file node[cookbook_name]['robot']['ssh_dir'] + "/authorized_keys" do
  source "authorized_keys-bastion"
  owner  node[cookbook_name]['robot']['user']
  group  node[cookbook_name]['robot']['group']
  mode   0600
  action :create
end

# Add the command that... runs chef on all frontend nodes in this environment.
# This script does two different things. If run on a bastion host, it SSHes into
# frontend hosts and runs itself. But if run on a frontend host, it actually runs
# sudo chef-client.

cookbook_file node[cookbook_name]['robot']['home'] + "/run-chef-on-all-frontend-nodes-in-this-environment.sh" do
  source "run-chef-on-all-frontend-nodes-in-this-environment.sh"
  owner  node[cookbook_name]['robot']['user']
  group  node[cookbook_name]['robot']['group']
  mode   0544
  action :create
end

# Bastion host needs the ability to run "sudo git pull".
cookbook_file "/etc/sudoers.d/chef-robot-bastion" do
  source "chef-robot-bastion"
  owner  'root'
  group  'root'
  mode   0440
  action :create
end


