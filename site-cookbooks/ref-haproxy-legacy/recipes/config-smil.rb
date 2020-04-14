haproxy_frontend "smil-bptfref-8090-ssltermination" do
  lines [
    "bind 0.0.0.0:" + node["ref-haproxy-legacy"]["smil"]["frontend"]["port"] + " ssl crt /etc/haproxy/ssl/legacy-xxl-star.mynexia.com.pem",
    "maxconn " + node["ref-haproxy-legacy"]["smil"]["frontend"]["maxconn"],
    "option tcpka",
    "default_backend smil-be"
  ]
end

node.default["ref-haproxy-legacy"]["smil"]["backend"]["server_config"] = 
  "weight"      + " " + node["ref-haproxy-legacy"]["smil"]["backend"]["weight"].to_s       + " " +
  "check inter" + " " + node["ref-haproxy-legacy"]["smil"]["backend"]["check_inter"].to_s  + " " +
  "rise"        + " " + node["ref-haproxy-legacy"]["smil"]["backend"]["rise"].to_s         + " " +
  "fall"        + " " + node["ref-haproxy-legacy"]["smil"]["backend"]["fall"].to_s         + " " +
  "maxconn"     + " " + node["ref-haproxy-legacy"]["smil"]["backend"]["maxconn"].to_s      + " " +
  "ssl"         + " " + node["ref-haproxy-legacy"]["smil"]["backend"]["ssl"].to_s          + " " +
  "ca-file"     + " " + node["ref-haproxy-legacy"]["smil"]["backend"]["ca-file"].to_s      + " " +
  "verifyhost"  + " " + node["ref-haproxy-legacy"]["smil"]["backend"]["verifyhost"].to_s   + " " +
  "slowstart"   + " " + node["ref-haproxy-legacy"]["smil"]["backend"]["slowstart"].to_s

haproxy_backend "smil-be" do
  lines node["ref-haproxy-legacy"]["smil"]["backend"]["hostnames"].map{|i| "server smil_manager #{i}:"+ node["ref-haproxy-legacy"]["smil"]["backend"]["port"] + " " + node["ref-haproxy-legacy"]["smil"]["backend"]["server_config"] }
end
