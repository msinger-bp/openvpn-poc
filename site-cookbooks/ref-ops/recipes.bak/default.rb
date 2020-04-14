# Cookbook Name:: ref-monitoring
# Recipe:: default
#
# Copyright 2019, BitPusher, LLC
#
# All rights reserved - Do Not Redistribute

##  APT
include_recipe 'apt'

include_recipe 'ref-monitoring::nginx_webserver'

##  NAGIOS
include_recipe 'ref-monitoring::nagios'

