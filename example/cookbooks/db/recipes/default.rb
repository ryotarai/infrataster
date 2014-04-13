include_recipe 'apt'

package 'mysql-server'

service 'mysql' do
  supports(:restart => true)
end

cookbook_file '/etc/mysql/my.cnf' do
  notifies :restart, 'service[mysql]'
end

execute "mysql -uroot -e \"GRANT ALL PRIVILEGES ON *.* TO 'app'@'#{node['app_ip']}' IDENTIFIED BY 'app';\""

