DROPLET=wercker-infrataster-$(date +%s)
tugboat create $DROPLET
tugboat wait $DROPLET
IPADDRESS=$(tugboat info $DROPLET | grep IP: | ruby -p -e 'sub(/.+?([\d\.]+)/, "\\1")')
echo $IPADDRESS
sleep 30
scp ./ci/test.bash root@$IPADDRESS
ssh root@$IPADDRESS 'bash -x ./test.bash'
tugboat destroy -c $DROPLET

