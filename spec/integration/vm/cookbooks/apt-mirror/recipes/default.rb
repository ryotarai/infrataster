if node['ci']
  execute "sed -i -e 's| http://[^/]\\+| http://mirrors.digitalocean.com|g' /etc/apt/sources.list"
else
  execute "sed -i -e 's| \\(http[^ ]\\+\\)| mirror://mirrors.ubuntu.com/mirrors.txt|g' /etc/apt/sources.list"
end

include_recipe 'apt'

