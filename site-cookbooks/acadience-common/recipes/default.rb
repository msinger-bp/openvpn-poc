# fix this as early as possible - blame systemd
link '/etc/resolv.conf' do
  to '/run/systemd/resolve/resolv.conf'
  link_type :symbolic
end

include_recipe 'bootstrap::users'

package 'emacs-nox'
package 'screen'
package 'nano'

include_recipe 'acadience-common::motd'
