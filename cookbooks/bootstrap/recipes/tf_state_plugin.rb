directory node['ohai']['plugin_path'] do
  owner 'root'
  group 'root'
  mode  0755
  action :create
end

cookbook_file "#{node['ohai']['plugin_path']}/ohai-tf.rb" do
  source 'ohai-tf.rb'
  owner  'root'
  group  'root'
  mode   0644
  action :create
end


