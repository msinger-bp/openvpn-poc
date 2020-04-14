The "chef" site-module creates an EFS volume for the Chef repo and also a "loader"
EC2 instance from which to initially clone the manually chef repo, so that
subsequently-launched instances can be programmed through user-data to automatically
mount the Chef EFS volume, install Chef, and run chef-client without further
operator management or intervention.

This process also depends on the specialized user-data script located at:

  site-modules/cloud.init.user.data/chef.user.data.tpl

