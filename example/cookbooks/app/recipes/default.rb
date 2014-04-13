include_recipe 'apt'

package 'python-software-properties' do
  action :install
end

execute 'apt-add-repository ppa:brightbox/ruby-ng && apt-get update'

package 'build-essential' do
  action :install
end

package 'ruby2.1' do
  action :install
end

package 'ruby2.1-dev' do
  action :install
end

execute 'gem install bundler' do
  not_if "gem list | grep -q 'bundler '"
end

execute 'bundle install' do
  cwd '/vagrant/sinatra_app'
end

execute "kill $(cat /tmp/thin.pid) && sleep 2" do
  only_if "test -e /tmp/thin.pid"
end

execute "bundle exec thin start --pid /tmp/thin.pid --daemonize --port 80" do
  cwd '/vagrant/sinatra_app'
end

