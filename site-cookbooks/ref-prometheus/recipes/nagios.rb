nagios_service 'default-service' do
  options 'service_description' => 'default-service',
          'register'            => 0
end

nagios_command 'check_dummy' do
  options 'command_line' => '/usr/lib/nagios/plugins/check_dummy 0 check_dummy'
end

nagios_service 'check_host_ssh' do
  options 'use' => 'default-service',
          'check_command' => 'check_dummy',
          'hostgroup_name' => 'all'
end

# This must be done last
include_recipe "nagios::default"
