# Add authorized_keys file for chef-robot that can ONLY run "sudo chef-client".
cookbook_file "/home/chef-robot/.ssh/authorized_keys" do
  source "authorized_keys-frontend"
  owner  'chef-robot'
  group  'nogroup'
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

