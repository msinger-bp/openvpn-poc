default['ohai']['plugin_path'] = '/etc/chef/ohai/plugins'
default['bootstrap']['recipe_list'] = [ 'bootstrap::tf_state_plugin', 'bootstrap::users' ]

##EOF
