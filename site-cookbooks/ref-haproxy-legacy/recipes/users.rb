# ref-haproxy-legacy/recipes/users.rb
# last edit 2019 May 29

cookbook_file "/etc/sudoers.d/sysadmin" do
  source "sudoers-sysadmin"
  mode '0440'
  owner 'root'
  group 'root'
end

users_manage 'sysadmin' do
  group_id 10999
  action [:create]
  data_bag 'users'
end

