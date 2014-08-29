name             'pe_network'
maintainer       'Platform Engineering'
maintainer_email 'platform-engineering@springer.com'
license          'Apache 2.0'
description      'Network and FW configuration for servers'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

%w{ debian ubuntu centos redhat  }.each do |os|
  supports os
end

depends 'afw', '~> 0.0.7'  
