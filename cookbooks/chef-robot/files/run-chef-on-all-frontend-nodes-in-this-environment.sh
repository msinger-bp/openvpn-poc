#!/bin/bash

# This script is executed automagically upon successful frontend build by
# Travis - see https://travis-ci.com/github/Emberex/Acadience
#
# It does just what it says on the tin: It runs chef on all frontend nodes
# in the current environment.
#
# Attn BitPusher engineers:
# This is part of the deploy procedure as noted at:
# https://mwiki.bitpusher.com/index.php/Acadience_Deployments
#
# This should be the only script chef-robot is allowed to run.
# Make this so via ensuring that /home/chef-robot/.ssh/authorized_keys
# looks like this:
# command="sh ~/run-chef-on-all-frontend-nodes-in-this-environment.sh",no-port-forwarding,no-x11-forwarding,no-agent-forwarding ssh-rsa KEY_GOES_HERE
#
# The command is first executed on the bastion host for a given environment,
# which iterates across all front-end nodes in /var/chef/nodes, SSHes into
# each of them in turn, and runs 'sudo chef-client'.
#
# Since this method of restricting access allows just ONE command, we're being
# SOOPAR CLEVAR and making one single script that does both "halves" of this
# process. If the script thinks we're on a "-frontend-" node, it'll run
# "sudo chef-client". If it thinks we are NOT on a "-frontend-" node, it will
# SSH into the frontend nodes and run the script.
#
# If hostnames get screwed up (notably if one or more of the -frontend-
# instances is misconfigured and thinks it's a bastion host), this could
# infinite-loop, so there is a sleep in here just in case.


AM_I_BASTION=`hostname | grep "\-bastion\-" | wc -l`;

if [ $AM_I_BASTION -gt 0 ]; then
	# "-bastion-" detected in the output of "hostname".
	# I think I am the bastion node. SSH into each -frontend- node,
	# and run myself (which should run 'sudo chef-client') on them,
	(cd /var/chef; sudo git pull)
	sleep 2; # Just in case a frontend box thinks it's a bastion and
	         # causes an infinite loop
	for I in $(ls -1 /var/chef/nodes | grep -- '-frontend-' | sed -e 's:.json::g'); do
		ssh $I run-chef-on-all-frontend-nodes-in-this-environment.sh;
	done
else
	AM_I_FRONTEND=`hostname | grep "\-frontend\-" | wc -l`;
	if [ $AM_I_FRONTEND -gt 0 ]; then
		# "-frontend-" detected in the output of "hostname".
		# I think I am a frontend node. Run sudo chef-client.
		sudo chef-client
	else
		echo "ERROR: I cannot identify if this node is a frontend or a bastion. So I will do nothing."
		exit 1
	fi
fi

