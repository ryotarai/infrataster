cd /tmp

sudo apt-get update

sudo apt-get install -y dpkg-dev virtualbox-dkms
wget -O vagrant.deb https://dl.bintray.com/mitchellh/vagrant/vagrant_1.5.4_x86_64.deb
sudo dpkg -i vagrant.deb
sudo apt-get install -y linux-headers-$(uname -r)
sudo dpkg-reconfigure virtualbox-dkms

vagrant box add --provider=virtualbox hashicorp/precise32
# precise64 doesn't work on digitalocean

sudo apt-get install -y python-software-properties
sudo apt-add-repository -y ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install -y ruby2.1 git ruby2.1-dev libxslt1-dev libxml2-dev build-essential libgecode-dev libmysqlclient-dev phantomjs

sudo gem install bundler --no-ri --no-rdoc



