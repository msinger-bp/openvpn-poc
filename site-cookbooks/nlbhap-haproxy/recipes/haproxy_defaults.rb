haproxy_default 'log' do
  directive 'log'
  value 'global'
end
haproxy_default 'mode' do
  directive 'mode'
  value 'http'
end
