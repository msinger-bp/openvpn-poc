#!/bin/bash -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
#echo "$HOSTNAME - sensei" > index.html
#nohup busybox httpd -f -p "${SERVER_PORT}" &
apt-get update
apt-get -y install nginx
mkdir /var/www/html/sensei
echo "I am $HOSTNAME, serving Sensei" > /var/www/html/sensei/index.html
systemctl start nginx
