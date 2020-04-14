include_recipe 'nlbhap-haproxy::haproxy_defaults'
include_recipe 'nlbhap-haproxy::haproxy_globals'
include_recipe 'nlbhap-haproxy::service_enable'

##  STREAM CONFIG INVOCATION
include_recipe 'nlbhap-haproxy::haproxy_nlb1stream1'
include_recipe 'nlbhap-haproxy::haproxy_nlb1stream2'
include_recipe 'nlbhap-haproxy::haproxy_nlb2stream1'
include_recipe 'nlbhap-haproxy::haproxy_nlb2stream2'
