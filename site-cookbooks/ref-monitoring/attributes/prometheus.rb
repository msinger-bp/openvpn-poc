default['ref-monitoring']['repo']               = 'prom/graphite-exporter'
default['ref-monitoring']['tag']                = 'v0.6.2'
default['ref-monitoring']['container']['user']  = 'nobody'
default['ref-monitoring']['container']['group'] = 'nogroup'
default['ref-monitoring']['container']['uid']   = 65534
default['ref-monitoring']['container']['gid']   = 65534
default['ref-monitoring']['prometheus']['cloudwatch-exporter']['delay_seconds']   = 300
default['ref-monitoring']['prometheus']['cloudwatch-exporter']['period_seconds']  = 60
