resource_name :prometheus_threshold

property :name,   String, name_property: true
property :values, Hash,   required: true

action :create do
  with_run_context :root do
    template_path="#{node['node_exporter']['textfile_path']}/#{new_resource.name}.prom"
    res_exists=true
    begin
      resources(template: template_path)
    rescue Chef::Exceptions::ResourceNotFound
      res_exists=false
    end
    if not res_exists #declare resources
      template template_path do
        cookbook   "prometheus_clients"
        source     "threshold.prom.erb"
        variables( lazy {{values: new_resource.values, metric: new_resource.name}} )
        action     :nothing
        not_if { ::File.exist?("#{template_path}.override") }
      end
      ruby_block "prepare_threshold::#{new_resource.name}" do
        block do
          true
        end
        notifies :create, "template[#{template_path}]", :delayed
      end
    else #resource exists, edit resource
      edit_resource(:template, template_path) do |new_resource|
        variables[:values].merge!(new_resource.values)
      end
    end
  end
end

## TYPE <%= @metric -%> untyped
#<% @values.each do |k,val| -%>
#  <% s||=[] -%>
#  <% k.each do |kk,vv| -%>
#    <% s << "#{kk}=\"#{vv}\"" -%>
#  <% end -%>
#<%= "threshold::#{@metric}{#{s.join(',')}} #{val}" %>
#<% end %>

#{{'device' => '/dev/xvda1', 'mountpoint' => '/'} =>    42,
# {'device' => '/dev/xvdb',  'mountpoint' => '/tmp'} => 420
#}

