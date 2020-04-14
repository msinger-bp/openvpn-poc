
#make some strings to make life easier...
prom_base_name="prometheus-#{node['prometheus']['version']}.linux-amd64"
prom_tarball_name="#{prom_base_name}.tar.gz"
prom_download_url="https://github.com/prometheus/prometheus/releases/download/v#{node['prometheus']['version']}/#{prom_tarball_name}"
prom_tarball_local_path="#{Chef::Config['file_cache_path']}/#{prom_tarball_name}"

# dependencies
%w{curl tar gzip}.each do |pkg|
  package pkg do
    action :install
  end
end

#system user/group
group node['prometheus']['group'] do
  system true
  action :create
end

user node['prometheus']['user'] do
  comment     'Prometheus service account'
  home        node['prometheus']['home_dir']
  gid         node['prometheus']['group']
  manage_home false
  system      true
  action      :create
end

# download tarballs
remote_file prom_tarball_local_path do
  source prom_download_url
  mode   0644
  action :create_if_missing
end

#unpack sources
execute 'unpack prometheus' do
  command "tar -zx -C #{node['prometheus']['install_prefix']} -f #{prom_tarball_local_path}"
  creates "#{node['prometheus']['install_prefix']}/#{prom_base_name}"
end

link "#{node['prometheus']['install_prefix']}/prometheus" do
  to "#{node['prometheus']['install_prefix']}/#{prom_base_name}"
end

# fixup directory ownership
["#{node['prometheus']['install_prefix']}/#{prom_base_name}", 
 "#{node['prometheus']['install_prefix']}/#{prom_base_name}/consoles",
 "#{node['prometheus']['install_prefix']}/#{prom_base_name}/console_libraries"].each do |d|
  directory d do
    owner node['prometheus']['user']
    group node['prometheus']['group']
    recursive true
  end
end

#template "#{node['prometheus']['install_prefix']}/prometheus/prometheus.yml" do
#  source 'prometheus.yml.erb'
#  owner  'prometheus'
#  group  'prometheus'
#  mode   0644
#end

#install init scripts
case node['platform']
when 'ubuntu'
  case node['platform_version']
  when '16.04', '18.04' #use systemd (and doves cry)
    execute 'reload_systemd' do
      command 'systemctl daemon-reload'
      action  :nothing
    end

    template '/etc/systemd/system/prometheus.service' do
      source   'prometheus.service.erb'
      mode     '0644'
      variables(
        :prom_binary => "#{node['prometheus']['install_prefix']}/prometheus/prometheus",
        :flags => node['prometheus']['flags'] + node['prometheus']['extra_flags']
      )
      notifies :run, 'execute[reload_systemd]', :immediate
      notifies :restart, 'service[prometheus]', :delayed
    end

    service 'prometheus' do
      action [:enable]
    end
  else
    Chef::Log.fatal("OS platform_version [#{node['platform_version']}] not supported by this cookbook/recipe.")
    raise
  end
else 
  Chef::Log.fatal("OS platform [#{node['platform']}] not supported by this cookbook/recipe.")
  raise
end

