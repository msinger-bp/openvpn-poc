file '/etc/default/prometheus-node-exporter' do
  content <<EOF
ARGS="--collector.diskstats.ignored-devices=^(ram|loop|fd|(h|s|v|xv)d[a-z]|nvme\\d+n\\d+p)\\d+$ \
      --collector.filesystem.ignored-mount-points=^/(var/lib/docker|sys|proc|dev|run)($|/) \
      --collector.netdev.ignored-devices=^lo$ \
      --collector.textfile.directory=/var/lib/prometheus/node-exporter"
EOF
  owner    'root'
  group    'root'
  mode     '0644'
end

include_recipe "prometheus_clients::node_exporter"

