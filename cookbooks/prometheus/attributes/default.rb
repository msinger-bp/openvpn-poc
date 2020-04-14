default['prometheus']['version']              = '2.3.1'
default['prometheus']['extra_flags']          = ''
default['prometheus']['install_prefix']       = '/opt'
default['prometheus']['home_dir']             = "#{node['prometheus']['install_prefix']}/prometheus"
default['prometheus']['config_file']          = "#{node['prometheus']['home_dir']}/prometheus.yml"
default['prometheus']['retention_time']       = '365d' #current prom default is 15d, which is not useful in the slightest.  1y might be more useful
default['prometheus']['user']                 = 'prometheus'
default['prometheus']['group']                = node['prometheus']['user']
default['prometheus']['flags']                = "--storage.tsdb.path=#{node['prometheus']['home_dir']}/data --config.file=#{node['prometheus']['config_file']} --storage.tsdb.retention.time=#{node['prometheus']['retention_time'}"
default['alertmanager']['version']            = '0.14.0'
default['alertmanager']['flags']              = ''
default['alertmanager']['extra_flags']        = ''

# prometheus.yml is derived from node['prometheus']['config']
default['prometheus']['config']['global']['scrape_interval'] = '15s'
default['prometheus']['config']['global']['evaluation_interval'] = '15s'
default['prometheus']['config']['alerting']['alertmanagers'] = []
default['prometheus']['config']['alerting']['alertmanagers'][0]={}
default['prometheus']['config']['alerting']['alertmanagers'][0]['static_configs']=[]
default['prometheus']['config']['alerting']['alertmanagers'][0]['static_configs'][0]={}
default['prometheus']['config']['alerting']['alertmanagers'][0]['static_configs'][0]['targets'] = [ 'alertmanager:9093' ]
default['prometheus']['config']['rule_files'] = []
