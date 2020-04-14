package 'prometheus-pushgateway' do
  action :install
end

service 'prometheus-pushgateway' do
  action [:enable, :restart]
end

prometheus_job 'pushgateway' do
  target  'localhost:9091'
  options ({'honor_labels' => true})
end
