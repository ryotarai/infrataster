DROPLET=wercker-infrataster-$(date +%s)
tugboat create $DROPLET
tugboat wait $DROPLET
IPADDRESS=$(tugboat info $DROPLET | grep IP: | ruby -p -e 'sub(/.+?([\d\.]+)/, "\\1")')
sleep 10
scp -c 'StrictHostKeyChecking no' ./ci/test.bash root@$IPADDRESS
ssh -c 'StrictHostKeyChecking no' root@$IPADDRESS 'bash -x ./test.bash'
tugboat destroy -c $DROPLET

