
#make some strings to make life easier...
am_base_name="alertmanager-#{node['alertmanager']['version']}.linux-amd64"
am_tarball_name="#{am_base_name}.tar.gz"
am_download_url="https://github.com/prometheus/alertmanager/releases/download/v#{node['alertmanager']['version']}/#{am_tarball_name}"
am_tarball_local_path="#{Chef::Config['file_cache_path']}/#{am_tarball_name}"

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
remote_file am_tarball_local_path do
  source am_download_url
  mode   0644
  action :create_if_missing
end

#unpack sources
execute 'unpack alertmanager' do
  command "tar -zx -C #{node['prometheus']['install_prefix']} -f #{am_tarball_local_path}"
  creates "#{node['prometheus']['install_prefix']}/#{am_base_name}"
end

directory "#{node['prometheus']['install_prefix']}/#{am_base_name}" do
  owner node['prometheus']['user']
  group node['prometheus']['group']
  recursive true
end

link "#{node['prometheus']['install_prefix']}/alertmanager" do
  to "#{node['prometheus']['install_prefix']}/#{am_base_name}"
end

# fixup directory ownership
["#{node['prometheus']['install_prefix']}/#{am_base_name}"].each do |d|
  directory d do
    owner node['prometheus']['user']
    group node['prometheus']['group']
    recursive true
  end
end

#install init scripts
case node['platform']
when 'ubuntu'
  case node['platform_version']
  when '16.04', '18.04' #use systemd (and doves cry)
    execute 'reload_systemd' do
      command 'systemctl daemon-reload'
      action  :nothing
    end

    template '/etc/systemd/system/alertmanager.service' do
      source   'alertmanager.service.erb'
      mode     '0644'
      variables(
        :am_binary => "#{node['prometheus']['install_prefix']}/alertmanager/alertmanager",
        :flags => node['alertmanager']['flags'] + node['alertmanager']['extra_flags']
      )
      notifies :run, 'execute[reload_systemd]', :immediate
      notifies :restart, 'service[alertmanager]', :delayed
    end

    service 'alertmanager' do
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

