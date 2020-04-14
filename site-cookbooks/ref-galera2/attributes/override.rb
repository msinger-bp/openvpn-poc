
##  DIRECTORIES
override['galera']['data_dir']   = node['terraform'][node.chef_environment]['modules'][0]['outputs']['galera2_mount_point_mysql_data']['value']
override['galera']['binlog_dir'] = node['terraform'][node.chef_environment]['modules'][0]['outputs']['galera2_mount_point_mysql_binlog']['value']
override['galera']['tmp_dir']    = node['terraform'][node.chef_environment]['modules'][0]['outputs']['galera2_mount_point_mysql_tmp']['value']

##  GALERA CLUSTER CONFIG
override['galera']['wsrep_cluster_name']    = "galera2"
override['galera']['wsrep_cluster_address'] = "gcomm://" + node['terraform'][node.chef_environment]['modules'][0]['outputs']['galera2_internal_ips']['value'].join(',')

##  FOR TESTING
#override['galera']['pxc_strict_mode']       = 'DISABLED'
