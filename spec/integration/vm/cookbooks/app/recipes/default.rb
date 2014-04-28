# install ruby and so on
package 'python-software-properties'

execute 'apt-add-repository ppa:brightbox/ruby-ng && apt-get update' do
  not_if 'test -e /etc/apt/sources.list.d/brightbox-ruby-ng-precise.list'
end

package 'build-essential'

package 'ruby2.1'

package 'ruby2.1-dev'

execute 'gem install bundler' do
  not_if "gem list | grep -q 'bundler '"
end

execute 'bundle install' do
  cwd '/vagrant/app'
end

# supervisor
package 'supervisor'

execute 'reload supervisor' do
  command 'supervisorctl reload'
  action :nothing
end

cookbook_file '/etc/supervisor/conf.d/rackup.conf' do
  notifies :run, 'execute[reload supervisor]'
end

execute 'supervisorctl restart rackup'

# db
package 'mysql-server'

service 'mysql' do
  action :start
  supports :restart => true
end

cookbook_file '/etc/mysql/my.cnf' do
  notifies :restart, 'service[mysql]'
end

execute "mysql -uroot -e \"GRANT ALL PRIVILEGES ON *.* TO 'app'@'%' IDENTIFIED BY 'app';\""

