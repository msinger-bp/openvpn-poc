template '/etc/mysql/percona-xtradb-cluster.conf.d/mysqld.cnf' do
  source 'mysqld.cnf.erb'
end
template '/etc/mysql/percona-xtradb-cluster.conf.d/wsrep.cnf' do
  source 'wsrep.cnf.erb'
end
