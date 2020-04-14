resource_name :haproxy_backend
property :name,    String,          name_property: true
property :lines,   [Array, String], required: true
property :comment, [String, nil],   default: nil

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
      conf[:name]=new_resource.name
      conf[:lines]=[new_resource.lines].flatten
      conf[:comment]=new_resource.comment unless new_resource.comment == nil
      variables[:back_ends] << conf
    end
  end
end

