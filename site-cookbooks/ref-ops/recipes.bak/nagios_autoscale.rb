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

