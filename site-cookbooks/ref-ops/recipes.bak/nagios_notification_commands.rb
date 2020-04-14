nagios_command 'notify-host-by-pagerduty' do
  options 'command_line' => '/usr/lib/nagios/plugins/notify_pagerduty.pl enqueue -f pd_nagios_object=host -f CONTACTPAGER="$CONTACTPAGER$" -f NOTIFICATIONTYPE="$NOTIFICATIONTYPE$" -f HOSTNAME="$HOSTNAME$" -f HOSTGROUP="$HOSTGROUPNAMES$" -f HOSTSTATE="$HOSTSTATE$" -f HOSTNOTES="$HOSTNOTES$" -f HOSTGROUPNOTESURL="$HOSTGROUPNOTESURL$"'
end

nagios_command 'notify-service-by-pagerduty' do
  options 'command_line' => '/usr/lib/nagios/plugins/notify_pagerduty.pl enqueue -f pd_nagios_object=service -f CONTACTPAGER="$CONTACTPAGER$" -f NOTIFICATIONTYPE="$NOTIFICATIONTYPE$" -f HOSTNAME="$HOSTNAME$" -f HOSTGROUP="$HOSTGROUPNAMES$"  SERVICEDESC="$SERVICEDESC$" -f SERVICESTATE="$SERVICESTATE$" -f HOSTNOTES="$HOSTNOTES$" -f HOSTGROUPNOTESURL="$HOSTGROUPNOTESURL$"'
end

nagios_command 'host_notify_by_email' do
  options 'command_line' => '/usr/bin/printf "%b" "$LONGDATETIME$\n\n$HOSTALIAS$ $NOTIFICATIONTYPE$ $HOSTSTATE$\n\n$HOSTOUTPUT$\n\nLogin: ssh://$HOSTNAME$\n\n$HOSTNOTES$\n\n" | ' + node['nagios']['server']['mail_command'] + ' -s "$NOTIFICATIONTYPE$ - $HOSTALIAS$ $HOSTSTATE$!" $CONTACTEMAIL$'
end

nagios_command 'service_notify_by_email' do
  options 'command_line' => '/usr/bin/printf "%b" "$LONGDATETIME$ - $SERVICEDESC$ $SERVICESTATE$\n\n$HOSTALIAS$  $NOTIFICATIONTYPE$\n\n$SERVICEOUTPUT$\n\nLogin: ssh://$HOSTNAME$\n\n$HOSTNOTES$\n\n" | ' + node['nagios']['server']['mail_command'] + ' -s "** $NOTIFICATIONTYPE$ - $HOSTALIAS$ - $SERVICEDESC$ - $SERVICESTATE$" $CONTACTEMAIL$'
end
