#!/bin/bash -ex

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo 'chef site-module user data (shell script) running' | tee -a /var/log/cloud.init.user.data.run.order

##  MOUNT CHEF-EFS NFS VOLUME
apt-get update
apt-get -y install nfs-common
mkdir -p ${CHEF_EFS_MOUNT_DIR}
mount \
    -t nfs4 \
    -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 \
    ${CHEF_EFS_VOL_MOUNT_TARGET}:/ ${CHEF_EFS_MOUNT_DIR}

apt-get -y install git

