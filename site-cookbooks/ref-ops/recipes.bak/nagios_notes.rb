##  CONFIGURE NAGIOS NOTES, TOUTAPP-STYLE
#notes_url_base='https://mwiki.bitpusher.com/index.php/ToutApp_VPC'
## Set notes_url for hostgroups and nodes within
#%w{core-adhoc core-app core-cron core-db core-dbproxy core-deploy core-memcache core-redis core-worker core-worker-alerter core-worker-background core-worker-cacher core-worker-cachewarmer core-worker-email core-worker-fileprocessing core-worker-longjobs core-worker-scheduler linker-app linker-cron linker-db linker-dbproxy linker-deploy linker-memcache linker-redis linker-worker-accesscontrol linker-worker-eventcreator linker-worker-notifier linker-worker-spamnotifier}.each do |role|
  #nagios_hostgroup role do
    #options 'notes_url' => "#{notes_url_base}##{role}"
  #end
#
  #search(:node, "role:#{role}").each do |node|
    #if node[:fqdn]
      #nagios_host node[:fqdn] do
        #options 'notes_url' => "#{notes_url_base}##{role}"
      #end
    #end
  #end
#end

