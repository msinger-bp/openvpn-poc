#directory '/var/lib/haproxy' do
#  owner 'haproxy'
#  group 'haproxy'
#  mode '0755'
#end

directory '/var/lib/haproxy/dev' do
  owner 'root'
  group 'root'
  mode '0755'
end

directory '/etc/haproxy' do
  owner 'root'
  group 'root'
  mode '0755'
end

directory '/etc/haproxy/ssl' do
  owner 'root'
  group 'haproxy'
  mode '0640'
end

cookbook_file "/etc/haproxy/ssl/legacy-xxl-star.mynexia.com.pem" do
  source "legacy-xxl-star.mynexia.com.pem"
  mode '0640'
  owner 'root'
  group 'haproxy'
end

cookbook_file "/etc/haproxy/ssl/#{node['env']['web_ssl_pem']}" do
  #source "2020-star.mynexia.com.pem"
  mode '0640'
  owner 'root'
  group 'haproxy'
end

cookbook_file "/etc/haproxy/ssl/#{node['env']['internal_root_ca_file']}" do
  #source "demo-ca-root.crt.pem"
  mode '0640'
  owner 'root'
  group 'haproxy'
end

#link "/etc/haproxy/ssl/internal-ca-root.crt.pem" do
#  to "/etc/haproxy/ssl/#{node['haproxy-oldssl']['internal-root-crt']}"
#end

##  LOGGING

cookbook_file "/etc/rsyslog.d/49-haproxy.conf" do
  source "49-haproxy.conf"
  mode '0644'
  owner 'root'
  group 'root'
end

cookbook_file "/etc/logrotate.d/haproxy" do
  source "logrotate-haproxy"
  mode '0644'
  owner 'root'
  group 'root'
end

