#!/bin/bash -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
#echo "$HOSTNAME - prometheus" > index.html
#nohup busybox httpd -f -p "${SERVER_PORT}" &
apt-get update
apt-get -y install nginx
mkdir /var/www/html/prometheus
echo "I am $HOSTNAME, serving Prometheus" > /var/www/html/prometheus/index.html
systemctl start nginx
