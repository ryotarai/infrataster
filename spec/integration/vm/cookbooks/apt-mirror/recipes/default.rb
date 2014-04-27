execute "sed -i -e 's| \\(http[^ ]\\+\\)| mirror://mirrors.ubuntu.com/mirrors.txt|g' /etc/apt/sources.list"

include_recipe 'apt'

