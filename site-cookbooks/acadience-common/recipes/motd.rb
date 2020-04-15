%w{10-help-text 50-landscape-sysinfo 50-motd-news 51-cloudguest 80-esm 80-livepatch 95-hwe-eol 97-overlayroot}.each do |i|
  motd i do
    action :delete
  end
end

include_recipe 'motd::cow'
