#
# Cookbook Name:: bp-nagios
# Recipe:: redshift
#
# Copyright 2017, BitPusher, LLC
#
# All rights reserved - Do Not Redistribute
#

cookbook_file '/var/lib/nagios/.pgpass' do
  source       'var/lib/nagios/.pgpass'
  mode         '0400'
  owner        'nagios'
  group        'nagios'
  action       :create
end

%w{pitches events pitch_templates deals users}.each do |table|
  cookbook_file "/etc/nagios3/conf.d/check_multi/analytics_redshift_#{table}.cmd" do
    source       "etc/nagios3/conf.d/check_multi/analytics_redshift_#{table}.cmd"
    mode         '0644'
    owner        'nagios'
    group        'nagios'
    action       :create
  end

  nagios_command "check_dms_stale_#{table}" do
    options "command_line" => "$USER1$/check_multi -f #{node['nagios']['config_dir']}/check_multi/analytics_redshift_#{table}.cmd -n 'DMS stale table #{table}'"
  end

  nagios_service "dms_stale_#{table}" do
    options 'description'           => "DMS stale table #{table}",
            'hostgroup_name'        => "monitoring",
            'service_template'      => "default-service",
            'check_command'         => "check_dms_stale_#{table}",
            'notifications_enabled' => 1,
            'max_check_attempts'    => 10
  end
end

nagios_command "check_analytics_redshift_pgsql" do
  options "command_line" => "$USER1$/check_pgsql -H toutapp-prod.cauofzzhsm1x.us-east-1.redshift.amazonaws.com -P 5439 -l dms -d $ARG1$ -q 'SELECT DATEDIFF(seconds,updated_at,sysdate) FROM $ARG2$ WHERE id = $ARG3$' -W 600 -C 900"
end

# prod database
nagios_service "dms_stale_pitches_prod" do
  options "description"           => "(DMS) Stale pitches in prod",
          "hostgroup_name"        => "monitoring",
          "service_template"      => "default-service",
          "check_command"         => "check_analytics_redshift_pgsql!prod!pitches!530641",
          'notifications_enabled' => 0
end

nagios_service "dms_stale_events_prod" do
  options "description"           => "(DMS) Stale events in prod",
          "hostgroup_name"        => "monitoring",
          "service_template"      => "default-service",
          "check_command"         => "check_analytics_redshift_pgsql!prod!events!1314106",
          'notifications_enabled' => 0
end

nagios_service "dms_stale_pitch_templates_prod" do
  options "description"           => "(DMS) Stale pitch_templates in prod",
          "hostgroup_name"        => "monitoring",
          "service_template"      => "default-service",
          "check_command"         => "check_analytics_redshift_pgsql!prod!pitch_templates!60833",
          'notifications_enabled' => 0
end

nagios_service "dms_stale_deals_prod" do
  options "description"           => "(DMS) Stale deals in prod",
          "hostgroup_name"        => "monitoring",
          "service_template"      => "default-service",
          "check_command"         => "check_analytics_redshift_pgsql!prod!deals!20474",
          'notifications_enabled' => 0
end

nagios_service "dms_stale_users_prod" do
  options "description"           => "(DMS) Stale users in prod",
          "hostgroup_name"        => "monitoring",
          "service_template"      => "default-service",
          "check_command"         => "check_analytics_redshift_pgsql!prod!users!23617",
          'notifications_enabled' => 0
end

# prod_new database
nagios_service "dms_stale_pitches_prod_new" do
  options "description"           => "(DMS) Stale pitches in prod_new",
          "hostgroup_name"        => "monitoring",
          "service_template"      => "default-service",
          "check_command"         => "check_analytics_redshift_pgsql!prod_new!pitches!530641",
          'notifications_enabled' => 0
end

nagios_service "dms_stale_events_prod_new" do
  options "description"           => "(DMS) Stale events in prod_new",
          "hostgroup_name"        => "monitoring",
          "service_template"      => "default-service",
          "check_command"         => "check_analytics_redshift_pgsql!prod_new!events!1314106",
          'notifications_enabled' => 0
end

nagios_service "dms_stale_pitch_templates_prod_new" do
  options "description"           => "(DMS) Stale pitch_templates in prod_new",
          "hostgroup_name"        => "monitoring",
          "service_template"      => "default-service",
          "check_command"         => "check_analytics_redshift_pgsql!prod_new!pitch_templates!60833",
          'notifications_enabled' => 0
end

nagios_service "dms_stale_deals_prod_new" do
  options "description"           => "(DMS) Stale deals in prod_new",
          "hostgroup_name"        => "monitoring",
          "service_template"      => "default-service",
          "check_command"         => "check_analytics_redshift_pgsql!prod_new!deals!20474",
          'notifications_enabled' => 0
end

nagios_service "dms_stale_users_prod_new" do
  options "description"           => "(DMS) Stale users in prod_new",
          "hostgroup_name"        => "monitoring",
          "service_template"      => "default-service",
          "check_command"         => "check_analytics_redshift_pgsql!prod_new!users!23617",
          'notifications_enabled' => 0
end


