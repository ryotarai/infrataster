require 'net/http'
require 'uri'

apt_servers = Net::HTTP.get(URI.parse('http://mirrors.ubuntu.com/mirrors.txt')).split("\n")
# ftp.riken.jp is unstable and slow?
apt_servers.delete('http://ftp.riken.jp/Linux/ubuntu/')
apt_server = apt_servers[rand(apt_servers.size)]

execute "sed -i -e 's| \\(http[^ ]\\+\\)| #{apt_server}|g' /etc/apt/sources.list"

include_recipe 'apt'

