file '/usr/sbin/policy-rc.d' do
  mode '0755'
  content("#!/bin/sh\nexit 101\n")
end

apt_package 'apparmor' do
  action  :remove
end

execute 'apt-get-update' do
  command 'apt-get update'
  action  :nothing
end

remote_file '/root/percona-release_latest.generic_all.deb' do
  source  'https://repo.percona.com/apt/percona-release_latest.generic_all.deb'
end
dpkg_package 'apt-repo-percona-latest' do
  package_name  'percona-release_latest.generic_all'
  source        '/root/percona-release_latest.generic_all.deb'
  notifies      :run, resources(:execute => 'apt-get-update'), :immediately
end

apt_package 'percona-xtradb-cluster-57'

apt_package 'percona-xtradb-cluster-57-lock' do
    package_name  'percona-xtradb-cluster-57'
    provider      Chef::Provider::Package::Apt
    #version      node['...']['..._version']
    action        :lock
end

directory 'mysql-data' do
  path    node['galera']['data_dir']
  action  :create
  owner   'mysql'
  group   'mysql'
  mode    '750'
end
directory 'mysql-binlog' do
  path    node['galera']['binlog_dir']
  action  :create
  owner   'mysql'
  group   'mysql'
  mode    '750'
end
directory 'mysql-tmp' do
  path    node['galera']['tmp_dir']
  action  :create
  owner   'mysql'
  group   'mysql'
  mode    '750'
end

include_recipe 'logrotate::default'

logrotate_app 'mysqld_error_log' do
  path      node['galera']['error_log']['path']
  frequency node['galera']['error_log']['rotation_frequency']
  rotate    node['galera']['error_log']['rotation_count']
  create    '644 root adm'
end
logrotate_app 'mysqld_slow_query_log' do
  path      node['galera']['slow_query_log']['path']
  frequency node['galera']['slow_query_log']['rotation_frequency']
  rotate    node['galera']['slow_query_log']['rotation_count']
  create    '644 root adm'
end
