##  STREAM2 CONFIGURATION
##  DUPLICATE THIS FILE FOR ADDITIONAL STREAMS AND CHANGE NAME TO "streamX"
haproxy_frontend 'nlb1stream2' do
  lines [
    "  bind 0.0.0.0:"+node['nlb1stream2_haproxy_port'],
    "  default_backend nlb1stream2_backend"
  ]
end
haproxy_backend 'nlb1stream2_backend' do
  lines node['nlb1stream2_backend_host_list'].map{|i| "   server nlb1stream2_backend_server #{i}:"+node['nlb1stream2_backend_port']}
end
