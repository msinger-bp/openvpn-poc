# Bitpusher "internal" apt-get repo
# this would be used for installing the haproxy-sslv3 package (but we've already compiled manually on these servers)
apt_repository 's3-bitpusher-apt-get' do
  uri          'https://s3.amazonaws.com/apt-get'
  components   ['main']
  distribution node['lsb']['codename']
  action       :add
  trusted      true
end

# so we can install
package 'haproxy-sslv3' do
  action       :install
  package_name 'haproxy-sslv3'
end

service 'haproxy' do
  action [:enable]
end

