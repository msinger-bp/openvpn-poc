service 'nagios-nrpe-server' do
  action :nothing
end

# Check for high load.  This check defines warning levels and attributes
nrpe_check 'check_load' do
  #command "#{node['nrpe']['plugin_dir']}/check_load -r"
  command "#{node['nrpe']['plugin_dir']}/check_load"
  #warning_condition '30,20,10'
  warning_condition '6'
  #critical_condition '60,40,20'
  critical_condition '10'
  action :add
end

# Check all non-NFS/tmp-fs disks.
nrpe_check 'check_all_disks' do
  command "#{node['nrpe']['plugin_dir']}/check_disk"
  warning_condition '15%'
  critical_condition '5%'
  parameters "-R '/dev/nvme*'"
  action :add
end

# Check for excessive users.  This command relies on the service definition to
# define what the warning/critical levels and attributes are
nrpe_check 'check_users' do
  command "#{node['nrpe']['plugin_dir']}/check_users"
  action :add
end
