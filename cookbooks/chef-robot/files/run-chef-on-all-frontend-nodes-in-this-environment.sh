#!/bin/bash

# This script is executed automagically on the bastion host in an environment
# upon successful frontend build by Travis - see:
# https://travis-ci.com/github/Emberex/Acadience
#
# It does just what it says on the tin: It runs chef on all frontend nodes
# in the current environment.
#
# Attn BitPusher engineers:
# This automates part of the deploy procedure as noted at:
# https://mwiki.bitpusher.com/index.php/Acadience_Deployments
#
# This should be the only script chef-robot is allowed to run on bastion hosts.
# Make this so via ensuring that the chef robot user's .ssh/authorized_keys
# looks like this:
# command="sh ~/run-chef-on-all-frontend-nodes-in-this-environment.sh",no-port-forwarding,no-x11-forwarding,no-agent-forwarding ssh-rsa KEY_GOES_HERE
#
# When run (on a bastion host), this script iterates across all front-end
# nodes in /var/chef/nodes, SSHes into each of them in turn, and runs
# 'sudo chef-client'.
#


AM_I_BASTION=`hostname | grep "\-bastion\-" | wc -l`;

if [ $AM_I_BASTION -gt 0 ]; then
	# "-bastion-" detected in the output of "hostname".
	# I think I am the bastion node. SSH into each -frontend- node,
	# and run 'sudo chef-client'.

# The below git pull is is only needed if we want to push from something
# other than 'latest'. We don't need it for now.
#	(cd /var/chef; sudo git pull)


	for I in $(ls -1 /var/chef/nodes | grep -- '-frontend-' | sed -e 's:.json::g'); do
		ssh -t $I sudo chef-client;
	done
else
	echo "ERROR: This script should only be run on bastion hosts. Exiting.";
	exit 1
fi

