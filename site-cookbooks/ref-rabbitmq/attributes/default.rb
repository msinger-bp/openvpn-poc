
##  RABBITMQ-SERVER VERION
##  AS OF 11/2019, 3.7.21 IS THE LATEST SUPPORTED RELEASE
default['rabbitmq']['version'] = "3.7.21"

##  ERLANG VERSION
##  PIN ERLANG TO MAJOR VERSION 22 VIA AN APT SOURCE COMPONENT SPECIFICATION, LATEST VERSION AS OF 11/2019
##  SEE: https://www.rabbitmq.com/which-erlang.html
default['rabbitmq']['erlang']['apt']['components'] = ["erlang-22.x"]
##  WE COULD PIN DOWN A SPECIFIC SUB-VERSION LIKE THIS:
#default['rabbitmq']['erlang']['version']          = '1:22.1.5-1'

##  ERLANG INSTALLATION METHOD / SOURCE
##  DEFEAT THE ERLANG SOLUTIONS COOKBOOK
default['erlang']['install_method']      = ""
##  CAUSES THE RABBITMQ COOKBOOK TO TAKE CARE OF INSTALLING ERLANG REPOS, PACKAGES, ETC
default['rabbitmq']['erlang']['enabled'] = true

##  ENABLE SSL
#default['rabbitmq']['ssl']        = true
#default['rabbitmq']['ssl_cacert'] = '/path/to/cacert.pem'
#default['rabbitmq']['ssl_cert']   = '/path/to/cert.pem'
#default['rabbitmq']['ssl_key']    = '/path/to/key.pem'


##  CLUSTERING
default['rabbitmq']['clustering']['enable']                      = true
default['rabbitmq']['erlang_cookie']                             = 'AnyAlphaNumericStringWillDo'
default['rabbitmq']['clustering']['cluster_partition_handling']  = 'pause_minority'
default['rabbitmq']['clustering']['use_auto_clustering']         = true
default['rabbitmq']['clustering']['cluster_name']                = "#{node['environment_name']}-rabbitmq"
##  COMPOSE LIST OF MAPS OF RABBITMQ NODE NAMES FROM TERRAFORM CNAME LIST OUTPUT
default['rabbitmq']['clustering']['cluster_nodes'] = node['terraform'][node.chef_environment]['modules'][0]['outputs']['rabbitmq_internal_cnames']['value'].map { |n| { 'name': "rabbit@#{n}" } }

##  JOB CONTROL
default['rabbitmq']['job_control'] = 'systemd'
