tugboat create wercker-infrataster
tugboat wait wercker-infrataster
IPADDRESS=$(tugboat info wercker-infrataster | grep IP: | ruby -p -e 'sub(/.+?([\d\.]+)/, "\\1")')
echo $IPADDRESS
