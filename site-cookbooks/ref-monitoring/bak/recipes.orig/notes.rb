#
# Cookbook Name:: bp-nagios
# Recipe:: notes
#
# Copyright 2016, BitPusher, LLC
#
# All rights reserved - Do Not Redistribute
#

#Derive application "environment" from chef environment.  Default to production
app_env = 'production'
app_env = node.chef_environment unless node.chef_environment == '_default'


# fill in host notes for nodes in nagios
search(:node, '*.*').each do |node|
  role_name=[node[:application][:stack],node[:application][:role]].flatten.join('-') rescue nil
  if role_name
    note="This is a #{role_name} instance in the #{app_env} environment.  It is a #{node[:ec2][:instance_type]} instance located in #{node[:ec2][:placement_availability_zone]}."
    nagios_host node[:fqdn] do
      options 'notes' => note
    end
  end
end

    
  
