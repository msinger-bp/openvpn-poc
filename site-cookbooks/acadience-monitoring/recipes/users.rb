# site-cookbooks/nexia-prometheus/recipes/users.rb
# last edit 2019 Oct 22

users_manage 'monitoring' do
  group_id 20007
  action :create
end

