
##  WEB SERVER CONFIG
default['nagios']['server']['web_server']                       = 'nginx'
default['nagios']['server']['stop_apache']                      = true
override['apache']['listen_ports']                              = %w(9443 10443)
#override['apache']['mpm']                                       = 'worker'
#override['apache']['mpm']                                       = 'prefork'
default['nagios']['http_port']                                  = '9443'
default['nagios']['server']['install_method']                   = 'package'
#default['apache']['mod_php']['install_method']                  = 'package'
default['nagios']['server']['nginx_dispatch']                   = 'both'
default['nagios']['server_auth_method']                         = 'htauth'
default['nagios']['server']['redirect_root']                    = true
default['nagios']['host_name_attribute']                        = 'hostname'
default['nagios']['notifications_enabled']                      = '1'
default['apache']['service_name']                               = 'apache'

#default['nagios']['host_name_attribute']                       = 'fqdn'
#default['nagios']['multi_environment_monitoring']              = true
#default['nagios']['server_role']                               = 'monitoring'

##  SSL
default['nagios']['enable_ssl']                                 = false
## Use letsencrypt/getssl certs
#default['nagios']['ssl_cert_file']                             = '/etc/ssl/toutapp.com.crt'
#default['nagios']['ssl_cert_chain_file']                       = '/etc/ssl/toutapp.com.chain.crt'
#default['nagios']['ssl_cert_key']                              = '/etc/ssl/toutapp.com.key'

##  NAGIOS CONFIGURATION DEFAULTS
default['nagios']['conf']['interval_length']                    = 10
default['nagios']['default_host']['check_interval']             = 5
default['nagios']['default_host']['max_check_attempts']         = 5
default['nagios']['default_host']['notification_interval']      = 240
default['nagios']['default_host']['retry_interval']             = 5
default['nagios']['default_service']['check_interval']          = 1
default['nagios']['default_service']['max_check_attempts']      = 5
default['nagios']['default_service']['notification_interval']   = 240
default['nagios']['default_service']['retry_interval']          = 1

##  SYSADMIN CONTACT INFO
#normal['nagios']['users_databag_group']                        = 'sysadmin'
normal['nagios']['sysadmin_email']                              = 'acutchin+tf_ref_nagios_sysadmin@bitpusher.com'
normal['nagios']['sysadmin_sms_email']                          = '4157103430@msg.fi.google.com'

##  PAGERDUTY INTEGRATION
#default['nagios']['pagerduty']['service_notification_options']  = 'c,u,r'
#default['nagios']['pagerduty']['key']                           = '481ca44b5ed84f808d0140b8f2f1e8b7'

##  RDS MONITORING DETAILS
#default['bp-nagios']['rds-slave']['warning']                    = 600   # 10 minutes
#default['bp-nagios']['rds-slave']['critical']                   = 14400 # 4 hours
#default['bp-nagios']['rds-slave']['mysql_password']             = 'buZie8shoh9shaihu1de'

