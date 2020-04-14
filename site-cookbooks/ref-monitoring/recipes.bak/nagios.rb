
include_recipe 'ref-monitoring::nagios_global'
include_recipe 'ref-monitoring::nagios_hosts'
include_recipe 'ref-monitoring::nagios_hostgroups'
include_recipe 'ref-monitoring::nagios_checks'
include_recipe 'ref-monitoring::nagios_check_commands'
include_recipe 'ref-monitoring::nagios_notification_commands'
include_recipe 'ref-monitoring::nagios_services'

#include_recipe 'ref-monitoring::nagios_autoscale'
#include_recipe 'ref-monitoring::nagios_pagerduty'
#include_recipe 'ref-monitoring::nagios_redshift'
#include_recipe 'ref-monitoring::nagios_notes'
