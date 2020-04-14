
nagios_host 'default_generic_host_template' do
  options 'name'                         => 'default_generic_host_template',
          'register'                     => 0,
          'use'                          => 'server',
          'check_interval'               => 10,
          'notifications_enabled'        => 1,
          'event_handler_enabled'        => false,
          'flap_detection_enabled'       => true,
          'process_perf_data'            => false,
          'retain_status_information'    => 1,
          'retain_nonstatus_information' => 1,
          'notification_period'          => '24x7',
end

##  CREATE A NAGIOS HOST FOR EACH MONITORED INSTANCE BASED ON THE DEFAULT GENERIC HOST TEMPLATE
%w{node['ref-monitoring']['monitored_instances']}.each do |host_fqdn|
  nagios_host #{host_fqdn} do
    options 'use'           => 'default_generic_host_template',
            'host_name'     => #{host_fqdn},
  end
end
