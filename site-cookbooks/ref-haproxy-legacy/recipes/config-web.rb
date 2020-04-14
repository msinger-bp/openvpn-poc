haproxy_backend "web-nexia-be-80" do
  web_80_server_lines << "fullconn 250000"
  web_80_server_lines << "mode http"
  lines web_80_server_lines
end

haproxy_backend "web-nexia-be-443" do
  web_443_server_lines << "fullconn 250000"
  web_443_server_lines << "mode http"
  lines web_443_server_lines
end

def targetnode_to_map_web(targetnode)
  { :ip => targetnode[:ipaddress],
    :host => targetnode[:hostname]
  }
end

web_servers = search(:node, 'role:nexia-home-application-web').map(&method(:targetnode_to_map_web))

def web_80_server_line(targetnode)
	"server #{targetnode[:host]} #{targetnode[:ip]}:80 check inter 5 fall 10000 rise 1"
end

def web_443_server_line(targetnode)
	"server #{targetnode[:host]} #{targetnode[:ip]}:443 check inter 5 fall 10000 rise 1 ssl verify none"
end

web_80_server_lines = web_servers.map(&method(:web_80_server_line)).sort
web_443_server_lines = web_servers.map(&method(:web_443_server_line)).sort

haproxy_frontend "web-nexia-80" do
  lines [
         "bind 0.0.0.0:80",
         "maxconn 150000",
         "default_backend web-nexia-be-80",
         "mode http"
        ]
end

haproxy_frontend "web-nexia-443" do
  lines [
         "bind 0.0.0.0:443 ssl crt /etc/haproxy/ssl/#{node['env']['web_ssl_pem']}",
         "maxconn 150000",
         "default_backend web-nexia-be-443",
         "mode http"
        ]
end

