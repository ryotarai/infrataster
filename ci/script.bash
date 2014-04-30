set -ex

DROPLET=wercker-infrataster-$(date +%s)
tugboat create --size=63 --image=3346689 --region=6 $DROPLET
tugboat wait $DROPLET
IPADDRESS=$(tugboat info $DROPLET | grep IP: | ruby -p -e 'sub(/.+?([\d\.]+)/, "\\1")')

sleep 10

rsync -a -e "ssh -o 'StrictHostKeyChecking no'" . root@$IPADDRESS:~/src
ssh -o 'StrictHostKeyChecking no' root@$IPADDRESS 'cd src && bash -x ./ci/test.bash'

tugboat destroy -c $DROPLET

