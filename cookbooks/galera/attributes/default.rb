

default['galera']['open_files_limit']                     = '16384'
##  MYSQLD DIRECTORIES
default['galera']['data_dir']                             = "/var/lib/mysql"
default['galera']['binlog_dir']                           = "/var/lib/mysql/binlog"
default['galera']['tmp_dir']                              = "/tmp"

##  REPLICATION
default['galera']['wsrep_cluster_name']                   = ''
default['galera']['wsrep_cluster_address']                = ''
default['galera']['wsrep_provider_options']               = ''
default['galera']['wsrep_slave_threads']                  = '8'
default['galera']['pxc_strict_mode']                      = 'ENFORCING'

##  STATE TRANSFER
default['galera']['sst_user']                             = 'sstuser'
default['galera']['sst_password']                         = 'sstpassword'

##  BINLOG
default['galera']['sync_binlog']                          = '0'
default['galera']['expire_logs_days']                     = '7'

##  INNODB
default['galera']['innodb_flush_log_at_trx_commit']       = '2'
default['galera']['innodb_log_buffer_size']               = '16M'
default['galera']['innodb_log_file_size']                 = '96M'
default['galera']['innodb_lock_wait_timeout']             = '120'
default['galera']['innodb_thread_concurrency']            = '0'
default['galera']['innodb_flush_method']                  = 'O_DIRECT'
default['galera']['innodb_autoextend_increment']          = '128M'
default['galera']['innodb_buffer_pool_ram_pct']           = '60' ##  PERCENTAGE OF PHYSICAL RAM FOR 'innodb_buffer_pool_size'

##  APPLICATION LOG DIR (NOT BINLOGS)
default['galera']['app_log_dir']                          = '/var/log/mysql'

##  ERROR LOG
default['galera']['error_log']['verbosity']               = '2'
default['galera']['error_log']['filename']                = 'mysqld.error.log'
default['galera']['error_log']['path']                    = node['galera']['app_log_dir'] + '/' + node['galera']['error_log']['filename']
default['galera']['error_log']['rotation_frequency']      = 'daily'
default['galera']['error_log']['rotation_count']          = '30'

##  SLOW QUERY LOGGING
default['galera']['slow_query_log']['enable']                         = '1' ##  0 OR 1
default['galera']['slow_query_log']['long_query_time']                = '2'
default['galera']['slow_query_log']['log_queries_not_using_indexes']  = '0'
default['galera']['slow_query_log']['filename']                       = 'mysqld.slow.query.log'
default['galera']['slow_query_log']['path']                           = node['galera']['app_log_dir'] + '/' + node['galera']['slow_query_log']['filename']
default['galera']['slow_query_log']['rotation_frequency']             = 'daily'
default['galera']['slow_query_log']['rotation_count']                 = '30'

##  CONNECTIONS
default['galera']['max_connections']                      = '1000'
default['galera']['max_allowed_packet']                   = '128M'
default['galera']['max_connect_errors']                   = '9999999'

##  MISC
default['galera']['event_scheduler']                      = '0'
default['galera']['transaction_isolation']                = 'REPEATABLE-READ'
default['galera']['tmp_table_size']                       = '256M'
default['galera']['max_heap_table_size']                  = '384M'
default['galera']['sort_buffer_size']                     = '8M'
default['galera']['join_buffer_size']                     = '8M'
default['galera']['table_open_cache']                     = '4000'
default['galera']['collation_server']                     = 'utf8_unicode_ci'
default['galera']['group_concat_max_len']                 = '8192'
default['galera']['query_alloc_block_size']               = '16K'
default['galera']['have_query_cache']                     = '0'
default['galera']['character_set_server']                 = 'utf8'

