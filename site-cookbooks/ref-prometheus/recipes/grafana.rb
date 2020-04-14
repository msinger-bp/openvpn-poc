grafana_install 'grafana' do
end

grafana_config 'grafana'

grafana_config_users 'grafana' do
  allow_sign_up true
  allow_org_create true
  auto_assign_org false
  verify_email_enabled false
end

grafana_config_auth 'grafana' do
  login_cookie_name 'grafana_sess'
  action :install
end

service 'grafana-server' do
  action [:enable, :start]
end

#grafana_user 'chef' do
#    user(
#    name: 'chef',
#    email: 'nexia-ops@bitpusher.com',
#    password: 'flaGrx3z',
#    isAdmin: true
#  )
#  admin_user 'admin' # Set manually
#  admin_password 'admin'
#  action :create
#end

grafana_datasource 'prometheus' do
  datasource(
    type: 'prometheus',
    url: 'http://localhost:9090'
  )
  admin_user 'admin'
  admin_password 'admin'
  action :create
end
