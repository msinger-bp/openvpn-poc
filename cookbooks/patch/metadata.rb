name             'patch'
maintainer       'ISB'
maintainer_email 'isb@bitpusher.com'
license          'MIT'
description      'Some handy Chef resources for when you want to append, replace or delete and lines in files.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.2.2'

%w(amazon centos debian fedora redhat scientific ubuntu).each do |os|
	supports os
end
