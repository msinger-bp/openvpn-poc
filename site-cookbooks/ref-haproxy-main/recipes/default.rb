# haproxy_newssl/recipes/default.rb
# last edit 2019 Jun 27

#include_recipe 'ref-haproxy-main::users' ##  JUST SYSADMIN ACCOUNTS
include_recipe 'haproxy::install'

cookbook_file "/etc/logrotate.d/haproxy" do
  source "logrotate-haproxy"
  mode '0644'
  owner 'root'
  group 'root'
end

#===
# certs

directory '/etc/haproxy/ssl' do
  owner 'root'
  group 'haproxy'
  mode '0640'
end

cookbook_file "/etc/haproxy/ssl/2020-star.mynexia.com.pem" do
  source "2020-star.mynexia.com.pem"
  mode '0640'
  owner 'root'
  group 'haproxy'
end

#cookbook_file "/etc/haproxy/ssl/internal-ca-root.crt.pem" do
#cookbook_file "/etc/haproxy/ssl/#{node['haproxy-newssl'][node.chef_environment]['internal-root-crt']}" do
cookbook_file "/etc/haproxy/ssl/#{node['env']['internal_root_ca_file']}" do
  #source "#{node['haproxy-newssl'][node['env_name']]['internal-root-crt']}"
  #source "#{node['haproxy-newssl']['internal-root-crt']}"
  #source "demo-ca-root.crt.pem"
  mode '0640'
  owner 'root'
  group 'haproxy'
end

#link "/etc/haproxy/ssl/internal-ca-root.crt.pem" do
#  to "/etc/haproxy/ssl/#{node['haproxy-newssl']['internal-root-crt']}"
#end


#===
# node search and format server lines

# not needed; not restricting targets to same az 
#region_az = node['ec2']['placement_availability_zone']
#region_az =~ /(.)$/
#az_letter = Regexp.last_match[1]

#---
# camman

def targetnode_to_map_cam(targetnode)
  { :ip => targetnode[:ipaddress],
    :host => targetnode[:hostname]
  }
end

#camman_servers = search(:node, %Q{role:"camera_manager" AND name:"*-az#{az_letter}*"}).map(&method(:node_to_map_cam))
camman_servers = search(:node, 'role:camera_manager').map(&method(:targetnode_to_map_cam))
#camman_servers = search(:node, %Q{name:camman-az#{az_letter}*}).map(&method(:node_to_map_cam))

def camman_server_line(targetnode)
  #"server #{node[:host]} #{node[:ip]}:8859 check inter 5000 rise 2 fall 7 maxconn 30000"
  "server #{targetnode[:host]} #{targetnode[:ip]}:9859 weight 10 check inter 5000 rise 2 fall 7 maxconn 30000 ssl verify required ca-file /etc/haproxy/ssl/#{node['env']['internal_root_ca_file']} verifyhost smil-internal.nexia.secure"
end

camman_server_lines = camman_servers.map(&method(:camman_server_line)).sort

#---
# devman

def targetnode_to_map_dev(targetnode)
  { :ip => targetnode[:ipaddress],
    :host => targetnode[:hostname]
  }
end

#camman_servers = search(:node, %Q{role:"camera_manager" AND name:"*-az#{az_letter}*"}).map(&method(:node_to_map_cam))
devman_servers = search(:node, 'role:device_manager').map(&method(:targetnode_to_map_dev))
#camman_servers = search(:node, %Q{name:camman-az#{az_letter}*}).map(&method(:node_to_map_cam))

def devman_server_line(targetnode)
  #"server #{node[:host]} #{node[:ip]}:8879 check inter 5000 rise 2 fall 7 maxconn 30000"
  "server #{targetnode[:host]} #{targetnode[:ip]}:9879 weight 10 check inter 5000 rise 2 fall 7 maxconn 30000 ssl verify required ca-file /etc/haproxy/ssl/#{node['env']['internal_root_ca_file']} verifyhost smil-internal.nexia.secure"
end

devman_server_lines = devman_servers.map(&method(:devman_server_line)).sort

#---
# smil-module

#node.default[:internalrootcrt] = node['env']['internal_root_ca_file']

def targetnode_to_map_smil(targetnode)
  { :ip => targetnode[:ipaddress],
    :host => targetnode[:hostname],
  }
end

smil_mod_servers = search(:node, 'role:smil_module').map(&method(:targetnode_to_map_smil))

#testval = "#{node['haproxy-newssl']['internal-root-crt']}"

#Chef::Log.warn("attribute test #{node['env']['internal_root_ca_file']}")

def smil_server_line(targetnode)
    #testval = "#{node['haproxy-newssl']['internal-root-crt']}"
    #"server #{node[:host]} #{node[:ip]}:9090 weight 10 check inter 5000 rise 2 fall 7 maxconn 30000 ssl verify required ca-file /etc/haproxy/ssl/internal-ca-root.crt.pem verifyhost smil-internal.nexia.secure"
    "server #{targetnode[:host]} #{targetnode[:ip]}:9090 weight 10 check inter 5000 rise 2 fall 7 maxconn 30000 ssl verify required ca-file /etc/haproxy/ssl/#{node['env']['internal_root_ca_file']} verifyhost smil-internal.nexia.secure"
    #"server #{node[:host]} #{node[:ip]}:9090 weight 10 check inter 5000 rise 2 fall 7 maxconn 30000 ssl verify required ca-file /etc/haproxy/ssl/demo-ca-root.crt.pem verifyhost smil-internal.nexia.secure"
end

smil_server_lines = smil_mod_servers.map(&method(:smil_server_line)).sort

#===
# config file sections

#---
# global

haproxy_global "ga-log" do
  directive "log"
  value "/dev/log   local0"
end

haproxy_global "gb-log" do
  directive "log"
  value "/dev/log   local1 notice"
end

haproxy_global "gc-maxconn" do
  directive "maxconn"
  value "400000"
end

haproxy_global "gd-user" do
  directive "user"
  value "haproxy"
end

haproxy_global "ge-group" do
  directive "group"
  value "haproxy"
end

haproxy_global "gf-stats" do
  directive "stats"
  value "socket /var/run/haproxy.sock user haproxy group haproxy"
end

haproxy_global "gg-stats" do
  directive "stats"
  value "socket /var/run/haproxy_admin.sock mode 600 level admin"
end

haproxy_global "gh-ssl-default-bind-ciphers" do
  directive "ssl-default-bind-ciphers"
  value "ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS"
end

haproxy_global "gi-ssl-default-bind-options" do
  directive "ssl-default-bind-options"
  value "no-tls-tickets"
end

haproxy_global "gj-ssl-default-server-ciphers" do
  directive "ssl-default-server-ciphers"
  value "ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS"
end

haproxy_global "gk-ssl-default-server-options" do
  directive "ssl-default-server-options"
  value "no-tls-tickets"
end

haproxy_global "gl-stats" do
  directive "stats"
  value "timeout 30s"
end

haproxy_global "gm-tun.ssl.default-dh-param" do
  directive "tune.ssl.default-dh-param"
  value "2048"
end

#---
# defaults

haproxy_default "log" do
  directive "log"
  value "global"
end

haproxy_default "mode" do
  directive "mode"
  value "tcp"
end

haproxy_default "retries" do
  directive "retries"
  value "3"
end

haproxy_default "timeout-client" do
  directive "timeout client"
  value "3h"
end

haproxy_default "timeout-connect" do
  directive "timeout connect"
  value "50s"
end

haproxy_default "timeout-server" do
  directive "timeout server"
  value "2h"
end

haproxy_default "option-dontlognull" do
  directive "option dontlognull"
end

haproxy_default "option-redispatch" do
  directive "option redispatch"
end

haproxy_default "option-tcpka" do
  directive "option tcpka"
end

haproxy_default "option-tcplog" do
  directive "option tcplog"
end

haproxy_default "balance" do
  directive "balance"
  value "leastconn"
end

#===
# listeners / frontends

haproxy_listen "admin" do
  lines [
         "bind 0.0.0.0:8009",
         "mode http",
         "stats uri /",
         "stats realm HAProxy\ Statistics",
         "stats hide-version",
         "stats auth admin:nex1a$tats"
        ]
end

haproxy_frontend "cameras-nexia-8859" do
  lines [
         "bind 0.0.0.0:8859 ssl crt /etc/haproxy/ssl/2020-star.mynexia.com.pem",
         "maxconn 150000",
         "default_backend cameras-be"
        ]
end

haproxy_frontend "bridges-nexia-8879" do
  lines [
         "bind 0.0.0.0:8879 ssl crt /etc/haproxy/ssl/2020-star.mynexia.com.pem",
         "maxconn 150000",
         "default_backend bridges-be"
        ]
end

haproxy_frontend "smil-nexia-8090-ssltermination" do
  lines [
         "bind 0.0.0.0:8090 ssl crt /etc/haproxy/ssl/2020-star.mynexia.com.pem",
         "maxconn 150000",
         "option tcpka",
         "default_backend smil-be"
        ]
end

#===
# backends

haproxy_backend "cameras-be" do
  camman_server_lines << "fullconn 250000"
  lines camman_server_lines
  #lines [
  #       "server camman-azc00 10.150.41.59:8859 check maxconn 30000",
  #       "server camman-azd00 10.150.41.104:8859 check maxconn 30000",
  #       "fullconn 250000"
  #      ]
end

haproxy_backend "bridges-be" do
  devman_server_lines << "fullconn 250000"
  lines devman_server_lines
  #lines [
  #       "server devman-azc00 10.150.42.11:8879 check maxconn 30000",
  #       "server devman-azd00 10.150.42.70:8879 check maxconn 30000",
  #       "fullconn 250000"
  #      ]
end

haproxy_backend "smil-be" do
  #smil_server_lines << "fullconn 250000"
  lines smil_server_lines
  #lines [
  #       "server smil-module-azc00 10.150.55.61:9090 weight 10 check maxconn 30000 ssl verify required ca-file /etc/haproxy/ssl/#{node['env']['internal-root-crt']} verifyhost smil-internal.nexia.secure",
  # #      "server smil-module-azd00 10.150.55.85:9090 weight 10 check maxconn 30000 ssl verify required ca-file /etc/haproxy/ssl/internal-ca-root.crt.pem verifyhost smil-internal.nexia.secure",
  #       "fullconn 250000"
  #      ]
end

#===
# service enable
service 'haproxy' do
  action [:enable]
end

