execute "sed -i -e 's|http://archive.ubuntu.com/ubuntu|mirror://mirrors.ubuntu.com/mirrors.txt|g' /etc/apt/sources.list" 

execute 'apt-get update'

package 'nginx'

service 'nginx' do
  action :start
end

file '/etc/nginx/sites-enabled/default' do
  action :delete
end

template '/etc/nginx/sites-available/integration-test' do
  notifies :restart, 'service[nginx]'
end

link '/etc/nginx/sites-enabled/integration-test' do
  to '/etc/nginx/sites-available/integration-test'
end

remote_file '/usr/share/nginx/html/index.html' do
  mode '644'
end

remote_file '/usr/share/nginx/html/auth' do
  mode '644'
end

remote_file '/etc/nginx/.htpasswd' do
  mode '644'
end
