include_recipe "chef-robot"
# i.e., include the default recipe, chef-robot::default
# This ensures the chef-robot user actually exists! ;-)


# See default.rb for an explanation of the 'travisci_deployment' flag.
if node['env_flags']['travisci_deployment'] == true
  # Add authorized_keys file for chef-robot that can ONLY run the "run-chef-on-all-frontend-nodes-in-this-environment.sh" command.
  cookbook_file node[cookbook_name]['robot']['ssh_dir'] + "/authorized_keys" do
    source "authorized_keys-bastion"
    owner  node[cookbook_name]['robot']['user']
    group  node[cookbook_name]['robot']['group']
    mode   0600
    action :create
  end

  # Add the command that... runs chef on all frontend nodes in this env.

  cookbook_file node[cookbook_name]['robot']['home'] + "/run-chef-on-all-frontend-nodes-in-this-environment.sh" do
    source "run-chef-on-all-frontend-nodes-in-this-environment.sh"
    owner  node[cookbook_name]['robot']['user']
    group  node[cookbook_name]['robot']['group']
    mode   0544
    action :create
  end


  ## FOR FUTURE USE:
  ## For simply running chef against `latest`, our robot doesn't need
  ## to touch git.
  ## However, if we wish to give it the ability to run chef against
  ## a tag (e.g. 'v1.2.34'), it will need git access.
  ##
  ## How to grant said access:
  ## 1) Uncomment the cookbook_file block below.
  ## 2) Grant read-only access on the chef repo to the robot user's SSH key.
  ## 3) Uncomment this line in files/run-chef-on-all-frontend-nodes-in-this-environment.sh:
  ## #      (cd /var/chef; sudo git pull)


  #cookbook_file "/etc/sudoers.d/chef-robot-bastion" do
  #  source "chef-robot-bastion"
  #  owner  'root'
  #  group  'root'
  #  mode   0440
  #  action :create
  #end
end

