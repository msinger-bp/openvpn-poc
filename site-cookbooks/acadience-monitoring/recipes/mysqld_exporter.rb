tarball="/usr/src/mysqld_exporter-#{node['mysqld_exporter']['version']}.linux-amd64.tar.gz"

execute 'systemd-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end

remote_file tarball do
  source node['mysqld_exporter']['url']
  owner 'root'
  group 'root'
  mode  '0644'
  action :create_if_missing
  notifies :run, 'bash[install-mysqld_exporter]', :immediately
end

bash "install-mysqld_exporter" do
  cwd '/usr/src'
  code <<-EOH
tar -zxf #{tarball} -C /usr/src
install -o root -g root -m 0755 -p mysqld_exporter-#{node['mysqld_exporter']['version']}.linux-amd64/mysqld_exporter /usr/bin
EOH
  action :run
  not_if { ::File.exist?('/usr/bin/mysqld_exporter') }
  notifies :run, 'execute[systemd-reload]', :immediately
end

unit_file={}
prom_targets=[]
num=0
node['rds_instances'].map{|i| i.split('.').first}.each do |rds|
  svc_name="mysqld_exporter-rds-#{rds}"
  listen_addr = "127.42.#{num >> 8}.#{num & 0xff}:9104"
  hostsfile_entry listen_addr.split(':').first do
    hostname "rds-#{rds}.localhost"
  end
  prom_targets << "rds-#{rds}.localhost"
  num = num + 1

  service svc_name do
    action :nothing
  end

  unit_file[rds] = <<-EOH
[Unit]
Description=Mysqld exporter for prometheus (RDS #{rds})

[Service]
Type=simple
ExecStart=/usr/bin/mysqld_exporter --collect.auto_increment.columns --collect.binlog_size --collect.engine_innodb_status --collect.info_schema.innodb_metrics --collect.info_schema.innodb_tablespaces --collect.info_schema.processlist --collect.info_schema.query_response_time --collect.slave_hosts  --web.listen-address=#{listen_addr}
Environment=DATA_SOURCE_NAME='exporter:11exporter11@(#{rds}:3306)/'

[Install]
WantedBy=multi-user.target

EOH
     
  file "/etc/systemd/system/mysqld_exporter-rds-#{rds}.service" do
    content unit_file[rds]
    owner 'root'
    group 'root'
    mode  0644
    notifies :run, 'execute[systemd-reload]', :immediately
    notifies :restart, "service[mysqld_exporter-rds-#{rds}]", :immediately
  end
end 

node.normal['rds_prom_targets'] = prom_targets

