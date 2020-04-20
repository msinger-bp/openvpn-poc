default['aws']['ecr']['registry_id']                = '695990525005'
default['aws']['ecr']['region']                     = 'us-west-2'
default['acadience-frontend']['repo']               = '695990525005.dkr.ecr.us-west-2.amazonaws.com/frontend'
default['acadience-frontend']['tag']                = 'latest'
default['acadience-frontend']['container']['user']  = 'container'
default['acadience-frontend']['container']['group'] = 'container'
default['acadience-frontend']['container']['uid']   = 500 #node base image uses 1000/1000
default['acadience-frontend']['container']['gid']   = 500

default['db']['username']='app'
default['db']['password']='app-in-dev'
default['db']['host']=node['terraform'][node.chef_environment]['modules'][0]['outputs']['db-main_endpoint']

