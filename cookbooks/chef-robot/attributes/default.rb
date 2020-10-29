default['chef-robot']['robot']['user'] = 'chef-robot'
default['chef-robot']['robot']['uid'] = 501
default['chef-robot']['robot']['group'] = 'chef-robot'
default['chef-robot']['robot']['gid'] = 501
default['chef-robot']['robot']['home'] = "/home/" + default['chef-robot']['robot']['user']
default['chef-robot']['robot']['ssh_dir'] = default['chef-robot']['robot']['home'] + "/.ssh"

