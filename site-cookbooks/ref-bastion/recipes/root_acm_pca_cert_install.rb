package 'ca-certificates'

file '/usr/local/share/ca-certificates/root_acm_pca.crt' do
  content node['ref-bastion']['root_acm_pca_cert']
  notifies :run, 'bash[update-ca-certificates]', :immediately
end

bash 'update-ca-certificates' do
  code 'update-ca-certificates'
  action :nothing
end
