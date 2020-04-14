#
# Cookbook Name:: bp-nagios
# Recipe:: hostgroups
#
# Copyright 2016, BitPusher, LLC
#
# All rights reserved - Do Not Redistribute
#

#Derive application "environment" from chef environment.  Default to production
app_env = 'production'
app_env = node.chef_environment unless node.chef_environment == '_default'

notes_url_base='https://mwiki.bitpusher.com/index.php/ToutApp_VPC'

# Set notes_url for hostgroups and nodes within
%w{core-adhoc core-app core-cron core-db core-dbproxy core-deploy core-memcache core-redis core-worker core-worker-alerter core-worker-background core-worker-cacher core-worker-cachewarmer core-worker-email core-worker-fileprocessing core-worker-longjobs core-worker-scheduler linker-app linker-cron linker-db linker-dbproxy linker-deploy linker-memcache linker-redis linker-worker-accesscontrol linker-worker-eventcreator linker-worker-notifier linker-worker-spamnotifier}.each do |role|
  nagios_hostgroup role do
    options 'notes_url' => "#{notes_url_base}##{role}"
  end

  search(:node, "role:#{role}").each do |node|
    if node[:fqdn]
      nagios_host node[:fqdn] do
        options 'notes_url' => "#{notes_url_base}##{role}"
      end
    end
  end
end

