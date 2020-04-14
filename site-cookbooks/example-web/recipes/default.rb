package 'busybox' do
  action :install
end

directory "/var/www/html" do
  action :create
  recursive true
end

file "/var/www/html/index.html" do
  content "Hello World from #{node.name}\n"
  action :create
end

execute "launch busybox" do
  command "pkill -u root busybox; nohup busybox httpd -p 80 -h /var/www/html"
  cwd     '/var/www/html'
end
