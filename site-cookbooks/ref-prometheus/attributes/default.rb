default['ref-prometheus']['repo']               = 'prom/graphite-exporter'
default['ref-prometheus']['tag']                = 'v0.6.2'
default['ref-prometheus']['container']['user']  = 'nobody'
default['ref-prometheus']['container']['group'] = 'nogroup'
default['ref-prometheus']['container']['uid']   = 65534
default['ref-prometheus']['container']['gid']   = 65534

normal['nagios']['server']['load_normal_config'] = true
normal['nagios']['server']['load_databag_config'] = false
normal['nagios']['monitored_environments'] = [node.chef_environment]
normal['nagios']['enable_ssl'] = false
normal['nagios']['conf']['enable_notifications'] = 0
normal['nagios']['server']['web_server'] = 'nginx'
normal['nagios']['server']['nginx_dispatch']['cgi_url'] = 'fcgiwrap'
normal['nagios']['server']['nginx_dispatch']['php_url'] = 'php'
normal['nagios']['server']['nginx_dispatch']['type'] = 'both'

