#
# Cookbook Name:: bp-nagios
# Recipe:: autoscale
#
# Copyright 2016, BitPusher, LLC
#
# All rights reserved - Do Not Redistribute
#

#Derive application "environment" from chef environment.  Default to production
app_env = 'production'
app_env = node.chef_environment unless node.chef_environment == '_default'

# Set host check interval overrides for **NON** autoscaled groups back to "defaults"
%w{bastion core-dbproxy db elasticsearch-legacy linker-dbproxy ops percona percona-standalone-5-5 percona-standalone-5-6 redis}.each do |role|
  search(:node, "role:#{role}").each do |node|
    if node[:fqdn]
      nagios_host node[:fqdn] do
        options 'check_interval'     => '1',
                'max_check_attempts' => '5',
                'retry_interval'     => '1'
      end
    end
  end
end

