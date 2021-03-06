include_recipe "chef-robot"
# i.e., include the default recipe, chef-robot::default
# This ensures the chef-robot user actually exists! ;-)

# See default.rb for an explanation of the 'travisci_deployment' flag.
if node['env_flags']['travisci_deployment'] == true

  # Add authorized_keys file for chef-robot that can ONLY run "sudo chef-client".
  cookbook_file node[cookbook_name]['robot']['ssh_dir'] + "/authorized_keys" do
    source "authorized_keys-frontend"
    owner  node[cookbook_name]['robot']['user']
    group  node[cookbook_name]['robot']['group']
    mode   0600
    action :create
  end


  # Frontend hosts needs the ability to run "sudo chef-client".
  cookbook_file "/etc/sudoers.d/chef-robot-frontend" do
    source "chef-robot-frontend"
    owner  'root'
    group  'root'
    mode   0440
    action :create
  end

end
