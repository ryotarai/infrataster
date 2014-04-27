package 'nginx'

service 'nginx' do
  action :start
end

cookbook_file '/usr/share/nginx/www/index.html' do
  mode '0644'
end

