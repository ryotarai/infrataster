package 'nginx'

service 'nginx' do
  action :start
  supports :restart => true
end

file '/etc/nginx/sites-enabled/default' do
  action :delete
end

template '/etc/nginx/sites-available/integration-test'

link '/etc/nginx/sites-enabled/integration-test' do
  to '/etc/nginx/sites-available/integration-test'
  notifies :restart, 'service[nginx]'
end

cookbook_file '/usr/share/nginx/www/index.html' do
  mode '0644'
end

cookbook_file '/usr/share/nginx/www/auth' do
  mode '0644'
end

cookbook_file '/etc/nginx/.htpasswd' do
  mode '0644'
end
