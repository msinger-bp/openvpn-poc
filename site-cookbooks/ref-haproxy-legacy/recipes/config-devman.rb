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
  "server #{targetnode[:host]} #{targetnode[:ip]}:9879 weight 10 check inter 5000 rise 2 fall 7 maxconn 30000 ssl verify required ca-file /etc/haproxy/ssl/#{node['env']['internal_root_ca_file']} verifyhost smil-internal.nexia.secure slowstart 10m"
end

devman_server_lines = devman_servers.map(&method(:devman_server_line)).sort

haproxy_backend "bridges-be" do
  devman_server_lines << "fullconn 250000"
  lines devman_server_lines
end
