include_recipe 'apt'

package "nginx" do
  action :install
end

service "nginx" do
  action :start
  supports(:reload => true)
end

file "/etc/nginx/sites-enabled/default" do
  action :delete
  notifies :reload, 'service[nginx]'
end

%w!app static!.each do |app|
  template "/etc/nginx/sites-available/#{app}" do
    notifies :reload, 'service[nginx]'
  end

  link "/etc/nginx/sites-enabled/#{app}" do
    to "/etc/nginx/sites-available/#{app}"
  end
end

