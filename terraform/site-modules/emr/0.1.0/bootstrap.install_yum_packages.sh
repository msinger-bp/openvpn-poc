#!/bin/bash

echo "install_packages.sh running" >> /var/log/bootstrap.run.log

for PKG in $@; do
  echo "INSTALLING $PKG"
  echo "===================================="
  sudo yum install -y $PKG
  echo
  echo
done

exit 0
