##  ADMIN
default["ref-haproxy-legacy"]["admin"]["listen_port"] = "8009"
default["ref-haproxy-legacy"]["admin"]["auth_user"]   = "admin"
default["ref-haproxy-legacy"]["admin"]["auth_pass"]   = "nex1a$tats"


##  SMIL
default["ref-haproxy-legacy"]["smil"]["frontend"]["maxconn"]    = "150000"
default["ref-haproxy-legacy"]["smil"]["frontend"]["port"]       = "8090"
default["ref-haproxy-legacy"]["smil"]["backend"]["hostnames"]   = node["terraform"][node.chef_environment]["modules"][0]["outputs"]["smil-managers_all"]["value"]
default["ref-haproxy-legacy"]["smil"]["backend"]["port"]        = "9090"
default["ref-haproxy-legacy"]["smil"]["backend"]["weight"]      = "10"
default["ref-haproxy-legacy"]["smil"]["backend"]["check_inter"] = "5000"
default["ref-haproxy-legacy"]["smil"]["backend"]["rise"]        = "2"
default["ref-haproxy-legacy"]["smil"]["backend"]["fall"]        = "7"
default["ref-haproxy-legacy"]["smil"]["backend"]["maxconn"]     = "30000"
default["ref-haproxy-legacy"]["smil"]["backend"]["ssl"]         = "verify required"
default["ref-haproxy-legacy"]["smil"]["backend"]["ca-file"]     = "/etc/haproxy/ssl/" + node["env"]["internal_root_ca_file"]
default["ref-haproxy-legacy"]["smil"]["backend"]["verifyhost"]  = "smil-internal.bptfref.secure"
default["ref-haproxy-legacy"]["smil"]["backend"]["slowstart"]   = "10m"

##  NOT SURE IF THESE ARE USEFUL ANY LONGER
#override["haproxy"]["install_recipe"] = "ref-haproxy-legacy::haproxy_install"
#default["ref-haproxy-legacy"]["internal-root-crt"] = "dummy value"

