TO DO:

* SSL

* PIN SPECIFIC ERLANG VERSION?

  default['rabbitmq']['erlang']['version'] = '1:22.1.5-1'

* RANDOMIZE ERLANG COOKIE FOR SECURITY?

  default['rabbitmq']['erlang_cookie'] = 'AnyAlphaNumericStringWillDo'

* WARNING

  Using the deprecated config parameter 'rabbit.log_levels' together with a new parameter for log categories. 'rabbit.log_levels' will be ignored. Please remove it from the config. More at https://rabbitmq.com/logging.html completed with 0 plugins.


INITIALIZE RABBITMQ CLUSTER FROM BASTION

1. STOP RABBITMQ-SERVER SERVICE AND RESTART IN DETACHED MODE ON EACH NODE

  [<you>@bastion-01]# for host in `ls /var/chef/nodes/*rabbit* | xargs -r -n 1 basename | sed -e 's/.json//'`; do echo $host; echo ---------------------; ssh $host 'sudo service rabbitmq-server stop; sudo rabbitmq-server -detached; ps aguxw | grep rabbit'; echo; echo; done

2. JOIN 02... TO CLUSTER

  [<you>@bastion-01]# for host in `ls /var/chef/nodes/*rabbit* | xargs -r -n 1 basename | sed -e 's/.json//' | grep -v '01$'`; do echo $host; echo ---------------------; ssh $host 'sudo rabbitmqctl stop_app; sudo rabbitmqctl reset; sudo rabbitmqctl join_cluster rabbit@bptfref-actest-rabbitmq-01; sudo rabbitmqctl start_app;'; echo; echo; done

4. CHECK CLUSTER STATUS

  [<you>@bastion-01]# for host in `ls /var/chef/nodes/*rabbit* | xargs -r -n 1 basename | sed -e 's/.json//'`; do echo $host; echo ---------------------; ssh $host 'sudo rabbitmqctl cluster_status'; echo; echo; done

