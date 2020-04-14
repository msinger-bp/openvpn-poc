default['haproxy']['version']                   = '1.7'
default['haproxy']['install_recipe']            = 'haproxy::install'

##  NLB1 STREAM1 CONFIG FROM TERRAFORM STATE
default['nlb1stream1_haproxy_port']       = node['terraform'][node.chef_environment]['modules'][0]['outputs']['nlbhap_nlb1stream1_haproxy_port']['value']
default['nlb1stream1_backend_port']       = node['terraform'][node.chef_environment]['modules'][0]['outputs']['nlbhap_nlb1stream1_backend_port']['value']
default['nlb1stream1_backend_host_list']  = node['terraform'][node.chef_environment]['modules'][0]['outputs']['nlbhap_nlb1stream1_backend_host_list']['value']
##  NLB1 STREAM2 CONFIG FROM TERRAFORM STATE
default['nlb1stream2_haproxy_port']       = node['terraform'][node.chef_environment]['modules'][0]['outputs']['nlbhap_nlb1stream2_haproxy_port']['value']
default['nlb1stream2_backend_port']       = node['terraform'][node.chef_environment]['modules'][0]['outputs']['nlbhap_nlb1stream2_backend_port']['value']
default['nlb1stream2_backend_host_list']  = node['terraform'][node.chef_environment]['modules'][0]['outputs']['nlbhap_nlb1stream2_backend_host_list']['value']
##  NLB2 STREAM1 CONFIG FROM TERRAFORM STATE
default['nlb2stream1_haproxy_port']       = node['terraform'][node.chef_environment]['modules'][0]['outputs']['nlbhap_nlb2stream1_haproxy_port']['value']
default['nlb2stream1_backend_port']       = node['terraform'][node.chef_environment]['modules'][0]['outputs']['nlbhap_nlb2stream1_backend_port']['value']
default['nlb2stream1_backend_host_list']  = node['terraform'][node.chef_environment]['modules'][0]['outputs']['nlbhap_nlb2stream1_backend_host_list']['value']
##  NLB2 STREAM2 CONFIG FROM TERRAFORM STATE
default['nlb2stream2_haproxy_port']       = node['terraform'][node.chef_environment]['modules'][0]['outputs']['nlbhap_nlb2stream2_haproxy_port']['value']
default['nlb2stream2_backend_port']       = node['terraform'][node.chef_environment]['modules'][0]['outputs']['nlbhap_nlb2stream2_backend_port']['value']
default['nlb2stream2_backend_host_list']  = node['terraform'][node.chef_environment]['modules'][0]['outputs']['nlbhap_nlb2stream2_backend_host_list']['value']
##  TO DO: SHOULD WE FURTHER DEFINE "['nlbhap-haproxy']" FOR THESE VARIABLES TO AVOID COLLISION WITH DUPLICATE SITE-MODULES?
##  I.E., IF WE CREATE A 'nlbhap2' SITE-MODULE, WILL THE ABOVE "default['nlb1stream1_..." VARIABLES CONFLICT?
#default['nlbhap-haproxy']['nlb1stream1_haproxy_port']       = node['terraform'][node.chef_environment]['modules'][0]['outputs']['nlbhap_nlb1stream1_haproxy_port']['value']
#default['nlbhap-haproxy']['nlb1stream1_backend_port']       = node['terraform'][node.chef_environment]['modules'][0]['outputs']['nlbhap_nlb1stream1_backend_port']['value']
#default['nlbhap-haproxy']['nlb1stream1_backend_host_list']  = node['terraform'][node.chef_environment]['modules'][0]['outputs']['nlbhap_nlb1stream1_backend_host_list']['value']
