##  EC2 INSTANCE LISTS
default['ref-monitoring']['bastion_instances']        = node['terraform'][node.chef_environment]['modules'][0]['outputs']['bastion_internal_cnames']['value']
#default['ref-monitoring']['bastion_instances_public'] = node['terraform'][node.chef_environment]['modules'][0]['outputs']['bastion_public_cnames']['value']

##  AGGREGATE LISTS OF INSTANCES
#default['ref-monitoring']['all_instances']            = node['terraform'][node.chef_environment]['modules'][0]['outputs']['all_instances']['value']
default['ref-monitoring']['monitored_instances']      = node['terraform'][node.chef_environment]['modules'][0]['outputs']['monitored_instances']['value']
