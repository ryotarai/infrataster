DROPLET=wercker-infrataster-$(date +%s)
tugboat create --size=66 --image=3101045 --region=6 $DROPLET
tugboat wait $DROPLET
IPADDRESS=$(tugboat info $DROPLET | grep IP: | ruby -p -e 'sub(/.+?([\d\.]+)/, "\\1")')
sleep 10
scp -o 'StrictHostKeyChecking no' -r . root@$IPADDRESS:~/src
ssh -o 'StrictHostKeyChecking no' root@$IPADDRESS 'cd src && bash -x ./ci/test.bash'
tugboat destroy -c $DROPLET

