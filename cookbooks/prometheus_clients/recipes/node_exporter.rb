package 'prometheus-node-exporter' do
  action :install
end

service 'prometheus-node-exporter' do
  action [:enable, :restart]
end
