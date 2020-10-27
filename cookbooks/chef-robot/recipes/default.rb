
# Used for chef-robot, a member of nogroup
# For now, this will create EVERY user in "nogroup".
# (For the moment, there is only one user there anyways...
#  ...but I want a cleaner solution for the future.)
users_manage 'nogroup' do
  group_name 'nogroup'
  action :create
end

