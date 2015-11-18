execute "sed -i -e 's|http://archive.ubuntu.com/ubuntu|mirror://mirrors.ubuntu.com/mirrors.txt|g' /etc/apt/sources.list"

execute 'apt-get update'

package 'python-software-properties'

execute 'apt-add-repository -y ppa:brightbox/ruby-ng && apt-get update'

package 'build-essential'

package 'ruby2.2'

package 'ruby2.2-dev'

gem_package "bundler"

execute 'bundle install' do
  cwd '/vagrant/app'
end

# supervisor
package 'supervisor'

execute 'reload supervisor' do
  command 'supervisorctl reload'
  action :nothing
end

remote_file '/etc/supervisor/conf.d/rackup.conf' do
  notifies :run, 'execute[reload supervisor]'
end

execute 'supervisorctl restart rackup'
