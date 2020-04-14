case node['platform']
    when "ubuntu"
        case node['platform_version']
            when "14.04"
                apt_repository 'vbernat-haproxy-1.8-ppa' do
                    uri                     'ppa:vbernat/haproxy-1.8'
                    distribution            'trusty'
                end
                apt_package 'haproxy-install' do
                    package_name            'haproxy'
                    #options                '--force-yes'
                    provider                Chef::Provider::Package::Apt
                    #version                node['bp-base']['haproxy_version']  ## LOCK VERSION
                    action                  :install
                end
                #apt_package 'haproxy-lock' do                                  ## LOCK VERSION
                #    package_name           'haproxy'
                #    provider               Chef::Provider::Package::Apt
                #    version                node['bp-base']['haproxy_version']
                #    action                 :lock
                #end
            when "16.04"
                apt_repository 'vbernat-haproxy-1.8-ppa' do
                    uri                     'ppa:vbernat/haproxy-1.8'
                    distribution            'xenial'
                end
                apt_package 'haproxy-install' do
                    package_name            'haproxy'
                    provider                Chef::Provider::Package::Apt
                    action                  :install
                end
            when "18.04"
#                 package 'haproxy' do
#                   action :install
#                 end
                apt_repository 'vbernat-haproxy-1.8-ppa' do
                    uri                     'ppa:vbernat/haproxy-1.8'
                    distribution            'xenial'
                end
                apt_package 'haproxy-install' do
                    package_name            'haproxy'
                    provider                Chef::Provider::Package::Apt
                    action                  :install
                end
        end
end

service 'haproxy' do
  action [:enable]
end

