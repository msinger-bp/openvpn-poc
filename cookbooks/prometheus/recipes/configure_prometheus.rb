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

#make Hash from Mash and do some sanity checks to make it more likely we write a good config
conf=node['prometheus']['config'].to_hash.compact
conf['rule_files'] = nil if conf['rule_files'].empty?
conf['alerting'] = nil if conf['alerting']['alertmanagers'].empty?

template node['prometheus']['config_file'] do
  source   'prometheus.yml.erb'
  action   :nothing
  owner    node['prometheus']['user']
  group    node['prometheus']['group']
  notifies :restart, 'service[prometheus]', :delayed
  variables( lazy {{conf: conf}} )
end

ruby_block 'notify_prom_template' do
  block do
    true
  end
  notifies :create, "template[#{node['prometheus']['config_file']}]", :delayed
end
