nagios_service "elasticsearch" do
  options "description"           => "ElasticSearch",
          "hostgroup_name"        => "elasticsearch-prod",
          "service_template"      => "default-service",
          "check_command"         => "check_elasticsearch",
          'notifications_enabled' => 0
end

nagios_service "elasticsearch_cluster" do
  options "description"           => "ElasticSearch Cluster",
          "hostgroup_name"        => "monitoring",
          "service_template"      => "default-service",
          "check_command"         => "check_elasticsearch_multi"
end

nagios_service "all_disk" do
  options "description" => "Memory",
          "hostgroup_name" => "base",
          "service_template" => "default-service",
          "check_command" => "all_disk"
end

nagios_service "ro_mounts" do
  options "description"           => "Read Only mounts",
          "hostgroup_name"        => "elasticsearch-prod",
          "service_template"      => "default-service",
          "check_command"         => "ro_mounts"
end

nagios_service "check_mongodb" do
  options "description" => "check MongoDB",
          "hostgroup_name" => "gmail-service-mongodb",
          "service_template" => "default-service",
          "check_command" => "check_mongodb"
end

nagios_service "check_mongodb_backups" do
  options "description" => "mongodb backups",
          "hostgroup_name" => "gmail-service-mongodb",
          "service_template" => "default-service",
          "check_command" => "check_mongodb_backups",
          "notification_period" => "bitpusher_business_hours"
end

nagios_service "check_nodejs_http" do
  options "description" => "check nodejs",
          "hostgroup_name" => "gmail-service-app",
          "service_template" => "default-service",
          "check_command" => "check_nodejs"
end

nagios_service "mysql" do
  options "description" => "MySQL Database Server",
          "hostgroup_name" => "db",
          "service_template" => "default-service",
          "check_command" => "mysql"
end

nagios_service "pmp_innodb" do
  options "description" => "InnoDB Table Status",
          "hostgroup_name" => "percona",
          "service_template" => "default-service",
          "check_command" => "pmp_innodb"
end

nagios_service "pmp_num_threads" do
  options "description" => "MySQL Number Threads Running",
          "hostgroup_name" => "percona",
          "service_template" => "default-service",
          "check_command" => "pmp_num_threads"
end

nagios_service "pmp_processlist" do
  options "description" => "MySQL Process List",
          "hostgroup_name" => "percona",
          "service_template" => "default-service",
          "check_command" => "pmp_processlist",
          "retry_interval" => 2
end

nagios_service "pmp_repl_delay" do
  options "description" => "MySQL Replcation Delay",
          "hostgroup_name" => "percona",
          "service_template" => "default-service",
          "max_check_attempts" => "5",
          "retry_interval" => "60",
          "check_command" => "pmp_repl_delay"
end

nagios_service "pmp_slave_exec" do
  options "description" => "MySQL Slave Exec Mode",
          "hostgroup_name" => "percona",
          "service_template" => "default-service",
          "check_command" => "pmp_slave_exec"
end

nagios_service "pmp_threads_vs_connections" do
  options "description" => "MySQL Number Threads vs Available Connections",
          "hostgroup_name" => "percona",
          "service_template" => "default-service",
          "check_command" => "pmp_threads_vs_connections"
end

nagios_service "pmp_wsrep_state" do
  options "description" => "MySQL Replication State",
          "hostgroup_name" => "percona",
          "service_template" => "default-service",
          "check_command" => "pmp_wsrep_state"
end

nagios_service "redis" do
  options "description" => "Redis",
          "hostgroup_name" => "redis",
          "service_template" => "lazy-service",
          "check_command" => "redis"
end

# Remove salt check as it doesn't work and just spams us incessantly
#nagios_service "salt" do
#  options "description" => "Salt Test Ping",
#          "hostgroup_name" => "base",
#          "service_template" => "lazy-service",
#          "check_command" => "salt"
#end

nagios_service "varnish" do
  options "description" => "Varnish",
          "hostgroup_name" => "cache",
          "service_template" => "default-service",
          "check_command" => "varnish"
end

nagios_service "check_adam_http" do
  options "description" => "check adam",
          "hostgroup_name" => "adam-app",
          "service_template" => "default-service",
          "check_command" => "check_adam"
end

nagios_service "wowza" do
  options "description" => "Wowza",
          "hostgroup_name" => "recording",
          "service_template" => "default-service",
          "check_command" => "wowza"
end

nagios_service "load" do
  options "description" => "Load",
          "hostgroup_name" => "base",
          "service_template" => "default-service",
          "check_command" => "load"
end

nagios_service "mem" do
  options "description" => "Memory",
          "hostgroup_name" => "base",
          "service_template" => "default-service",
          "check_command" => "mem"
end

nagios_service "memcache" do
  options "description" => "Memcache",
          "hostgroup_name" => "memcache",
          "service_template" => "lazy-service",
          "check_command" => "memcache"
end

nagios_service "nfs" do
  options "description" => "NFS Server",
          "hostgroup_name" => "store",
          "service_template" => "default-service",
          "check_command" => "nfs"
end

nagios_service "ntp" do
  options "description" => "NTP Server",
          "hostgroup_name" => "ntp",
          "service_template" => "default-service",
          "check_command" => "ntp"
end

nagios_service "ntpd_time" do
  options "description" => "NTP Time",
          "hostgroup_name" => "base",
          "service_template" => "default-service",
          "check_command" => "ntpd_time"
end

nagios_service "proc_keepalived" do
  options "description" => "KeepaliveD Process",
          "hostgroup_name" => "keepalived",
          "service_template" => "default-service",
          "check_command" => "proc_keepalived"
end

nagios_service "proc_ntpd" do
  options "description" => "NTP Process",
          "hostgroup_name" => "base",
          "service_template" => "default-service",
          "check_command" => "proc_ntpd"
end

nagios_service "sshd" do
  options "description" => "SSH Daemon",
          "hostgroup_name" => "base",
          "service_template" => "lazy-service",
          "check_command" => "sshd"
end

nagios_service "swap" do
  options "description" => "Swap",
          "hostgroup_name" => "base",
          "service_template" => "default-service",
          "check_command" => "swap"
end

nagios_service "tmpfs" do
  options "description" => "Tmpfs",
          "hostgroup_name" => "base",
          "service_template" => "default-service",
          "check_command" => "tmpfs"
end

##  RESQUE
nagios_service 'access_control_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'Access Control Queue Size',
          'hostgroup_name' => 'monitoring',
          'retry_interval' => '3',
          'check_command' => 'check_resque_queue_linker!access_control!200000!250000'
end

nagios_service 'notify_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'Notify Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_linker!notify!1000!5000'
end

nagios_service 'event_creation_queue_size' do
  options 'service_template' => 'default-service',
          'description' => 'Event Creation Queue Size',
          'hostgroup_name' => 'monitoring',
          'check_command' => 'check_resque_queue_linker!event_creation!2000!2500'
end

nagios_service 'rds_repl_delay' do
  options 'description'      => 'RDS Replcation Delay',
          'hostgroup_name'   => 'rds-slave',
          'service_template' => 'default-service',
          'check_command'    => 'rds_repl_delay'
end

##  SERVICE USING PROMETHEUS CHECK
define service {
    use                    default-service
    host_name              stage1-ops
    service_description    Kafka Lag - FMWE
    check_command          check_prometheus_extra_info!http://stage1-metrics1:9090!sum(kafka_consumer_group_lag{env='stage1',group='faceplate_message_worker_enqueuer'}) without (partition)!300!1800!FMWE_kafka_lag!ge
    }


