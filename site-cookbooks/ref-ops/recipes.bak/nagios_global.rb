nagios_timeperiod 'bitpusher_business_hours' do
  options 'alias' => '9AM to 8PM during the week',
          'times' => { 'sunday'    => '16:00-03:00',
                       'monday'    => '16:00-03:00',
                       'tuesday'   => '16:00-03:00',
                       'wednesday' => '16:00-03:00',
                       'thursday'  => '16:00-03:00',
                       'friday'    => '16:00-03:00',
                       'saturday'  => '16:00-03:00'
                     }
end

cron 'GetSSL update' do
  command "/usr/bin/getssl -u -q -a"
  minute  '15'
  hour    '4'
  user    'root'
  action  :create
end
