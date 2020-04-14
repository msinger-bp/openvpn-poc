haproxy_global 'chroot' do
  directive 'chroot'
  value '/var/lib/haproxy'
end
haproxy_global 'daemon' do
  directive 'daemon'
  value nil
end
haproxy_global 'user' do
  directive 'user'
  value 'haproxy'
end
haproxy_global 'group' do
  directive 'group'
  value 'haproxy'
end
