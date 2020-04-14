cookbook_file "/etc/haproxy/ssl/legacy-bridges.pem" do
  source "legacy-bridges.pem"
  mode '0640'
  owner 'root'
  group 'haproxy'
end

haproxy_frontend "bridges-nexia-8879" do
  lines [
         "bind 0.0.0.0:8879 ssl crt /etc/haproxy/ssl/legacy-bridges.pem",
         "maxconn 150000",
         "default_backend bridges-be"
        ]
end

haproxy_backend "bridges-be" do
  devman_server_lines << "fullconn 250000"
  lines devman_server_lines
end
