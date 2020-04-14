include_recipe 'ref-haproxy-legacy::install'
include_recipe 'ref-haproxy-legacy::config-general'
include_recipe 'ref-haproxy-legacy::config-global'
include_recipe 'ref-haproxy-legacy::config-defaults'
include_recipe 'ref-haproxy-legacy::config-admin'
include_recipe 'ref-haproxy-legacy::config-smil'

##  JUST INSTALLS SYSADMIN USERS - UNNECESSARY WITH NEW CHEF
#include_recipe 'ref-haproxy-legacy::users'
