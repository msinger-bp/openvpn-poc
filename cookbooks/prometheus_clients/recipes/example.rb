### THIS IS AN EXAMPLE!

# filesystem:filesystem_time_until_zero_free_hours:ratio_deriv1h{device="/dev/xvda1", mountpoint="/"}
prometheus_threshold "filesystem:filesystem_time_until_zero_free_hours:ratio_deriv1h" do
  values({
           {'device'=>'/dev/xvda1', 'mountpoint' => '/'         } => 42,
           {'device'=>'/dev/xvdb',  'mountpoint' => '/tmp'      } => 24,
           {'device'=>'/dev/xvdc',  'mountpoint' => '/srv/mysql'} => 240
         })
  action :create
end
