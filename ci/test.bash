echo 'deb http://download.virtualbox.org/virtualbox/debian precise contrib' > /etc/apt/sources.list.d/virtualbox.list
apt-get update
apt-get install -y virtualbox

wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.5.4_x86_64.deb
dpkg -i vagrant_1.5.4_x86_64.deb

vagrant -v

