
# attributes
default[:pe_network][:data_bag] = 'network'
default[:pe_network][:bag_name] = 'addr'
default[:pe_network][:environment] = node[:chef_environment]?node[:chef_environment]:"_default"
default[:pe_network][:udev] = "/etc/udev/rules.d/70-persistent-net.rules"


# definitions
default[:pe_network][:server] = {
   '192.168.1.2' => {
       'device' => "eth1",
       'mac' => "08:00:27:84:ee:e7"
   }
}


