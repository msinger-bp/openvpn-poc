package 'awscli'

Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
ruby_block 'get_ecr_login' do
  block do
    credentials = shell_out("aws ecr get-login --no-include-email --registry-ids #{node['aws']['ecr']['registry_id']} --region #{node['aws']['ecr']['region']}")
    node.default['aws']['ecr']['username'] = 'AWS'
    node.default['aws']['ecr']['password'] = credentials.stdout.split[5]
    node.default['aws']['ecr']['registry'] = credentials.stdout.split[6]
  end
end

docker_registry "https://#{node['aws']['ecr']['registry_id']}.dkr.ecr.#{node['aws']['ecr']['region']}.amazonaws.com" do
  username lazy { node['aws']['ecr']['username'] }
  password lazy { node['aws']['ecr']['password'] }
  email 'none'
end
