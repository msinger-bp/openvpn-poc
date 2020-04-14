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
