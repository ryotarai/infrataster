set -e

echo 'deb http://download.virtualbox.org/virtualbox/debian precise contrib' > /etc/apt/sources.list.d/virtualbox.list
apt-get update
apt-get install -y virtualbox

wget -O /tmp/vagrant.deb https://dl.bintray.com/mitchellh/vagrant/vagrant_1.5.4_x86_64.deb
dpkg -i /tmp/vagrant.deb

apt-get install -y python-software-properties
apt-add-repository ppa:brightbox/ruby-ng
apt-get update
apt-get install -y ruby2.1

bundle install
bundle exec rake spec:unit
bundle exec rake spec:integration:prepare
bundle exec rake spec:integration


