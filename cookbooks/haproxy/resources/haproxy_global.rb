GLOBAL_OPTIONS_14=['chroot', 'daemon', 'gid', 'group', 'log', 'log-send-hostname', 'nbproc', 'pidfile', 'uid', 'ulimit-n', 'user', 'stats', 'node', 'description', 'maxconn', 'maxpipes', 'noepoll', 'nokqueue', 'nopoll', 'nosepoll', 'nosplice', 'spread-checks', 'tune.bufsize', 'tune.chksize', 'tune.maxaccept', 'tune.maxpollevents', 'tune.maxrewrite', 'tune.rcvbuf.client', 'tune.rcvbuf.server', 'tune.sndbuf.client', 'tune.sndbuf.server', 'debug', 'quiet'].sort
GLOBAL_OPTIONS_17=%w{ca-base chroot crt-base cpu-map daemon description deviceatlas-json-file deviceatlas-log-level deviceatlas-separator deviceatlas-properties-cookie external-check gid group hard-stop-after log log-tag log-send-hostname lua-load nbproc node pidfile presetenv resetenv uid ulimit-n user setenv stats ssl-default-bind-ciphers ssl-default-bind-options ssl-default-server-ciphers ssl-default-server-options ssl-dh-param-file ssl-server-verify unix-bind unsetenv 51degrees-data-file 51degrees-property-name-list 51degrees-property-separator 51degrees-cache-size wurfl-data-file wurfl-information-list wurfl-information-list-separator wurfl-engine-mode wurfl-cache-size wurfl-useragent-priority max-spread-checks maxconn maxconnrate maxcomprate maxcompcpuusage maxpipes maxsessrate maxsslconn maxsslrate maxzlibmem noepoll nokqueue nopoll nosplice nogetaddrinfo noreuseport spread-checks server-state-base server-state-file tune.buffers.limit tune.buffers.reserve tune.bufsize tune.chksize tune.comp.maxlevel tune.http.cookielen tune.http.maxhdr tune.idletimer tune.lua.forced-yield tune.lua.maxmem tune.lua.session-timeout tune.lua.task-timeout tune.lua.service-timeout tune.maxaccept tune.maxpollevents tune.maxrewrite tune.pattern.cache-size tune.pipesize tune.rcvbuf.client tune.rcvbuf.server tune.recv_enough tune.sndbuf.client tune.sndbuf.server tune.ssl.cachesize tune.ssl.lifetime tune.ssl.force-private-cache tune.ssl.maxrecord tune.ssl.default-dh-param tune.ssl.ssl-ctx-cache-size tune.vars.global-max-size tune.vars.proc-max-size tune.vars.reqres-max-size tune.vars.sess-max-size tune.vars.txn-max-size tune.zlib.memlevel tune.zlib.windowsize debug quiet}.sort

_version=node['haproxy']['version'].split('.')
case _version[0] + '.' + _version[1]
when '1.4'
  GLOBAL_OPTIONS=GLOBAL_OPTIONS_14
when '1.7', '1.8'
  GLOBAL_OPTIONS=GLOBAL_OPTIONS_17
else
  Chef::Log.fatal("unknown HAProxy version.")
end

resource_name :haproxy_global
property :name,      String,                        name_property: true
property :directive, String,                        required: true, equal_to: GLOBAL_OPTIONS
property :value,     [Integer, String, Array, nil], default: nil
property :comment,   [String, nil],                 default: nil

#haproxy_global "logs" do
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
      variables[:globals] << conf
    end
  end
end

