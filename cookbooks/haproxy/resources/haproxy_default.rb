DEFAULT_DIRECTIVES_17=["backlog", "balance", "bind-process", "compression", "cookie", "default-server", "default_backend", "disabled", "email-alert from", "email-alert level", "email-alert mailers", "email-alert myhostname", "email-alert to", "enabled", "errorfile", "errorloc", "errorloc302", "errorloc303", "fullconn", "grace", "hash-type", "http-check disable-on-404", "http-check send-state", "http-reuse", "load-server-state-from-file", "log", "log-format", "log-format-sd", "log-tag", "max-keep-alive-queue", "maxconn", "mode", "monitor-net", "monitor-uri", "option abortonclose", "option accept-invalid-http-request", "option accept-invalid-http-response", "option allbackups", "option checkcache", "option clitcpka", "option contstats", "option dontlog-normal", "option dontlognull", "option forceclose", "option forwardfor", "option http-buffer-request", "option http-ignore-probes", "option http-keep-alive", "option http-no-delay", "option http-pretend-keepalive", "option http-server-close", "option http-tunnel", "option http-use-proxy-header", "option httpchk", "option httpclose", "option httplog", "option http_proxy", "option independent-streams", "option ldap-check", "option external-check", "option log-health-checks", "option log-separate-errors", "option logasap", "option mysql-check", "option nolinger", "option originalto", "option persist", "option pgsql-check", "option prefer-last-server", "option redispatch", "option redis-check", "option smtpchk", "option socket-stats", "option splice-auto", "option splice-request", "option splice-response", "option srvtcpka", "option ssl-hello-chk", "option tcp-check", "option tcp-smart-accept", "option tcp-smart-connect", "option tcpka", "option tcplog", "option transparent", "external-check command", "external-check path", "persist rdp-cookie", "rate-limit sessions", "retries", "server-state-file-name", "source", "stats auth", "stats enable", "stats hide-version", "stats realm", "stats refresh", "stats scope", "stats show-desc", "stats show-legends", "stats show-node", "stats uri", "timeout check", "timeout client", "timeout client-fin", "timeout connect", "timeout http-keep-alive", "timeout http-request", "timeout queue", "timeout server", "timeout server-fin", "timeout tarpit", "timeout tunnel", "unique-id-format", "unique-id-header"]
DEFAULT_DIRECTIVES=DEFAULT_DIRECTIVES_17

resource_name :haproxy_default
property :name,      String,                               name_property: true
property :directive, String,                               required: true, equal_to: DEFAULT_DIRECTIVES
property :value,     [Integer, String, true, false , nil], default: nil
property :comment,   [String, nil],                        default: nil

#haproxy_default "logs" do
#  directive "log"
#  value  ['127.0.0.1 local0', '127.0.0.1 local1 warn']
#  comment 'some comment'
#end

# data structure: [{:directive: 'directive_name', :value: ['values'], comment: 'directiveal comment'}, ...]

action :create do
  with_run_context :root do
    res_exists=true
    begin
      resources(template: '/etc/haproxy/haproxy.cfg')
    rescue Chef::Exceptions::ResourceNotFound
      res_exists=false
    end
    if not res_exists #declare resources
      globals=[]
      defaults=[]
      listeners=[]
      front_ends=[]
      back_ends=[]
      # First install the software
      include_recipe node['haproxy']['install_recipe']
      # Make sure directory exists for config template
      directory '/etc/haproxy' do
        action :create
      end
      template '/etc/haproxy/haproxy.cfg' do
        cookbook 'haproxy'
        source   'haproxy.cfg.erb'
        variables( lazy {
                     {globals:    globals,
                      defaults:   defaults,
                      listeners:  listeners,
                      front_ends: front_ends,
                      back_ends:  back_ends
                     }
                   } )
        action :nothing
        notifies :restart, 'service[haproxy]', :delayed
      end
      ruby_block 'prepare::haproxy.cfg' do
        block do
          true
        end
        notifies :create, "template[/etc/haproxy/haproxy.cfg]", :delayed
      end
    end
    # Now edit the templates...
    edit_resource(:template, '/etc/haproxy/haproxy.cfg') do |new_resource|
      # do the things
      conf={}
      conf[:directive]=new_resource.directive
      conf[:value]=[new_resource.value].flatten
      conf[:comment]=new_resource.comment unless new_resource.comment == nil
      variables[:defaults] << conf
    end
  end
end

