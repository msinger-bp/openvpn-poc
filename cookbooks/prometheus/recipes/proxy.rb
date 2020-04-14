#Setup nginx proxy
include_recipe "nginx::default"

prometheus_job "prometheus" do
  target  ['localhost:9090']
  path    '/metrics'
  action  :create
end
