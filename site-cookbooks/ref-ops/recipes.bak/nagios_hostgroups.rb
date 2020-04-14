
nagios_hostgroup 'bastions' do
  options 'alias'   => 'bastions',
          'members' => [ node['ref-monitoring']['bastion_instances'] ].join(',')
end

