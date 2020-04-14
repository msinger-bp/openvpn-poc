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
  value "no-tls-tickets ssl-min-ver SSLv3 ssl-max-ver TLSv1.3"
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
