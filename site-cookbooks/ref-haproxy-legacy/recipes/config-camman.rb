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

haproxy_backend "cameras-be" do
  camman_server_lines << "fullconn 250000"
  lines camman_server_lines
end

cookbook_file "/etc/haproxy/ssl/legacy-cameras.pem" do
  source "legacy-cameras.pem"
  mode '0640'
  owner 'root'
  group 'haproxy'
end

haproxy_frontend "cameras-nexia-8859" do
  lines [
         "bind 0.0.0.0:8859 ssl crt /etc/haproxy/ssl/legacy-cameras.pem",
         "maxconn 150000",
         "default_backend cameras-be"
        ]
end

