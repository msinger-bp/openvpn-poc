default['prometheus']['version'] = '2.14.0'

default['frontend_instances'] = node['terraform'][node.chef_environment]['modules'][0]['outputs']['frontend_internal_cnames']['value']
default['rds_instances'] = [node['terraform'][node.chef_environment]['modules'][0]['outputs']['maindb_endpoint']['value']].map {|i| i.split(':').first}

default['mysqld_exporter']['version'] = '0.12.1'
default['mysqld_exporter']['url']     = "https://github.com/prometheus/mysqld_exporter/releases/download/v#{node['mysqld_exporter']['version']}/mysqld_exporter-#{node['mysqld_exporter']['version']}.linux-amd64.tar.gz"

default['acadience-monitoring']['query-exporter']['repo']                  = '695990525005.dkr.ecr.us-west-2.amazonaws.com/prom/query-exporter'
default['acadience-monitoring']['query-exporter']['tag']                   = 'latest'
default['acadience-monitoring']['cloudwatch-exporter']['repo']             = 'prom/cloudwatch-exporter'
default['acadience-monitoring']['cloudwatch-exporter']['tag']              = 'cloudwatch_exporter-0.6.0'
default['acadience-monitoring']['container']['user']                       = 'nobody'
default['acadience-monitoring']['container']['group']                      = 'nogroup'
default['acadience-monitoring']['container']['uid']                        = 65534
default['acadience-monitoring']['container']['gid']                        = 65534

normal['nagios']['server']['load_normal_config']        = true
normal['nagios']['server']['load_databag_config']       = false
normal['nagios']['monitored_environments']              = [node.chef_environment]
normal['nagios']['enable_ssl']                          = false
normal['nagios']['conf']['enable_notifications']        = node['env_flags']['notifications_enabled'] ? 1 : 0 #nagios needs this to be 1|0, not true/false
normal['nagios']['server']['web_server']                = 'nginx'
normal['nagios']['server']['nginx_dispatch']['cgi_url'] = 'fcgiwrap'
normal['nagios']['server']['nginx_dispatch']['php_url'] = 'php'
normal['nagios']['server']['nginx_dispatch']['type']    = 'both'

# removing hard-coded environment configs, using environment file config now
#default['nexia-prometheus']['nagios-pagerduty']['qa']['key']                            = ''
#default['nexia-prometheus']['nagios-pagerduty']['qa']['service_notification_options']   = 'n'
#default['nexia-prometheus']['nagios-pagerduty']['qa']['host_notification_options']      = 'n'
#default['nexia-prometheus']['nagios-pagerduty']['qa']['contactgroups']                  = []
#default['nexia-prometheus']['nagios-pagerduty']['prod']['key']                          = '46802d49558d4cd6a7532d8a68fb695b'
#default['nexia-prometheus']['nagios-pagerduty']['prod']['service_notification_options'] = 'u,c,r'
#default['nexia-prometheus']['nagios-pagerduty']['prod']['host_notification_options']    = 'd,r'
#default['nexia-prometheus']['nagios-pagerduty']['prod']['contactgroups']                = [ 'admins' ]

#normal['nagios']['pagerduty']['key']                          = node['nexia-prometheus']['nagios-pagerduty'][node.chef_environment]['key']
#normal['nagios']['pagerduty']['service_notification_options'] = node['nexia-prometheus']['nagios-pagerduty'][node.chef_environment]['service_notification_options']
#normal['nagios']['pagerduty']['host_notification_options']    = node['nexia-prometheus']['nagios-pagerduty'][node.chef_environment]['host_notification_options']
#normal['nagios']['pagerduty']['contactgroups']                = node['nexia-prometheus']['nagios-pagerduty'][node.chef_environment]['contactgroups']

##  NOTE: THE SOUS-CHEFS NAGIOS COOKBOOK RELIES ON A DEFAULT INTERVAL_LENGTH OF 1 SECOND
##  RATHER THAN 1 MINUTE, SO SPECIFY ALL INTERVALS IN SECONDS
default['nagios']['default_host']['check_interval']           = 300
default['nagios']['default_host']['retry_interval']           = 60
default['nagios']['default_host']['max_check_attempts']       = 5
default['nagios']['default_host']['notification_interval']    = 1800
default['nagios']['default_service']['check_interval']        = 300
default['nagios']['default_service']['retry_interval']        = 60
default['nagios']['default_service']['max_check_attempts']    = 5
default['nagios']['default_service']['notification_interval'] = 1800
default['nagios']['conf']['status_update_interval']           = 15

default['nexia-prometheus']['prometheus']['cloudwatch-exporter']['delay_seconds']   = 300
default['nexia-prometheus']['prometheus']['cloudwatch-exporter']['period_seconds']  = 60

# For clownwatch-exporter
default['redis_instance_ids'] = []

default['mysql_instance_ids'] = [ node['terraform'][node.chef_environment]['modules'][0]['outputs']['maindb_id']['value']
                                ].flatten # replica ids are in array form

default['acadience-monitoring']['prometheus_endpoint'] = 'localhost'
