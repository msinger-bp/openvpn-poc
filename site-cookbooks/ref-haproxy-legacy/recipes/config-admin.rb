haproxy_listen "admin" do
  lines [
         "bind 0.0.0.0:" + node["ref-haproxy-legacy"]["admin"]["listen_port"],
         "mode http",
         "stats uri /",
         "stats realm HAProxy\ Statistics",
         "stats hide-version",
         "stats auth " + node["ref-haproxy-legacy"]["admin"]["auth_user"] + ":" + node["ref-haproxy-legacy"]["admin"]["auth_pass"]
        ]
end
