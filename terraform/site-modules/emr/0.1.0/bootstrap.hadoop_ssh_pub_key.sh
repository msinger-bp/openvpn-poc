#!/bin/bash

echo "ssh_pub_key.sh running" >> /var/log/bootstrap.run.log

echo "$1" >> /home/hadoop/.ssh/authorized_keys

exit 0
