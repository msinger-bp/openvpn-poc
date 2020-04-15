users_manage 'frontend' do
  group_id 20000
  action :create
end

if node['env_flags']['devs_have_sudo'] == true
  sudo "frontend" do
    group "frontend"
    nopasswd true
    env_keep_add ['SSH_AUTH_SOCK']
  end
end


