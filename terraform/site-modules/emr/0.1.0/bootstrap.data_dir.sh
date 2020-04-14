#!/bin/bash

echo "data_dir.sh running" >> /var/log/bootstrap.run.log

sudo mkdir /data

sudo chmod 1777 /data

exit 0
