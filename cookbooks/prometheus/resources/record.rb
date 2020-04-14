property :name,        String     , name_property: true
property :group_name,  String     , required: true
property :expression,  String     , required: true
property :labels,      [Hash, nil], default: nil

class Hash
  def compact
    def _empty?(val)
      case val
      when Hash     then val.compact.empty?
      when Array    then val.all? { |v| _empty?(v) }
      when String   then val.empty?
      when NilClass then true
      end
    end
    delete_if { |_key, val| _empty?(val) }
  end
end

action :create do
  with_run_context :root do
    res_exists=true
    begin
      resources(template: "#{node['prometheus']['home_dir']}/#{new_resource.group_name}_records.yml")
    rescue Chef::Exceptions::ResourceNotFound 
      res_exists=false
    end
    if not res_exists #First time this resource is created
      conf={}
      conf['groups']||=[]
      conf['groups'][0] ||= {}
      conf['groups'][0]['name']=new_resource.group_name
      conf['groups'][0]['rules']||=[]
      if node['prometheus'].attribute?('rules') and
        node['prometheus']['rules'].attribute?(new_resource.group_name) and 
        node['prometheus']['rules'][new_resource.group_name].attribute?('interval')
        conf['groups'][0]['interval'] = node['prometheus']['rules'][new_resource.group_name]['interval']
      end
      template "#{node['prometheus']['home_dir']}/#{new_resource.group_name}_records.yml" do
        cookbook 'prometheus'
        source   'rules.yml.erb'
        owner    node['prometheus']['user']
        group    node['prometheus']['group']
        action   :nothing
        notifies :restart, 'service[prometheus]', :delayed
        variables( lazy {{conf: conf}} )
      end
      ruby_block "prepare_prometheus_records::#{new_resource.group_name}" do
        block do
          true
        end
        notifies :create, "template[#{node['prometheus']['home_dir']}/#{new_resource.group_name}_records.yml]", :delayed
      end
      edit_resource(:template, node['prometheus']['config_file']) do |new_resource|
        variables[:conf]['rule_files'] = [] if variables[:conf]['rule_files'].nil?
        variables[:conf]['rule_files'] << "#{node['prometheus']['home_dir']}/#{new_resource.group_name}_records.yml"
      end
    end
    edit_resource(:template, "#{node['prometheus']['home_dir']}/#{new_resource.group_name}_records.yml") do |new_resource|
      r={}
      r['record']=new_resource.name
      r['labels']=new_resource.labels
      r['expr']=new_resource.expression
      variables[:conf]['groups'][0]['rules'] << r
    end
  end
end
