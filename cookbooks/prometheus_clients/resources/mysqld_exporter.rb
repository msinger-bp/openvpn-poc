resource_name :mysqld_exporter
property :name, String,  name_property: true
property :dsn,  String,  required: true
property :port, Integer, required: true

#mysqld_exporter 'RDS' do
#  dsn    "mysql://user:pass@(1.2.3.4:3306)/"
#  port   12345
#  action :create
#end
action :create do
  with_run_context :root do
    package 'prometheus-mysqld-exporter' do
      action :install
    end

    service 'prometheus-mysqld-exporter' do
      action [:disable, :stop]
    end

    execute 'reload_systemd' do
      command 'systemctl daemon-reload'
      action  :nothing
    end

    service "prometheus-mysqld-exporter-#{new_resource.name}" do
      action :nothing
    end

    template "/etc/systemd/system/prometheus-mysqld-exporter-#{new_resource.name}.service" do
      source  'etc/systemd/system/prometheus-mysqld-exporter.service.erb'
      cookbook 'prometheus_clients'
      variables({:name => new_resource.name})
      action :create
      notifies :run, 'execute[reload_systemd]', :immediate
      notifies :enable, "service[prometheus-mysqld-exporter-#{new_resource.name}]", :delayed
      notifies :restart, "service[prometheus-mysqld-exporter-#{new_resource.name}]", :delayed
    end

    template "/etc/default/prometheus-mysqld-exporter-#{new_resource.name}" do
      source  'etc/default/prometheus-mysqld-exporter.erb'
      cookbook 'prometheus_clients'
      variables({:port => new_resource.port,
                 :dsn  => new_resource.dsn})
      action :create
      notifies :enable, "service[prometheus-mysqld-exporter-#{new_resource.name}]", :delayed
      notifies :restart, "service[prometheus-mysqld-exporter-#{new_resource.name}]", :delayed
    end
  end
end

