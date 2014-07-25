
### Main attributes
default[:pe_network][:data_bag] = 'network'
default[:pe_network][:bag_name] = node[:hostname]
default[:pe_network][:environment] = node[:chef_environment] ? node[:chef_environment] : "_default"

### Network Definitions
default[:pe_network][:udev] = "/etc/udev/rules.d/70-persistent-net.rules"
default[:pe_network][:network] = {
   '192.168.1.2' => {
       :device => "eth2",
#      :network => "192.168.1.0",
#      :mask => "255.255.255.0",
#      :mac => "08:00:27:84:ee:e7",
#      :mtu => "1400",
#      :bcast => "192.168.1.255"
   }
}


### Firewall
default[:pe_network][:firewall][:enabled] = true
default[:pe_network][:firewall][:log] = true
# DROP all input packets by defaut
default[:pe_network][:firewall][:enable_input_drop] = true
# DROP all output packets by defaut
default[:pe_network][:firewall][:enable_output_drop] = false
# Rules
default[:pe_network][:firewall][:rules] = {
   'allow ssh' => {
      :direction => 'in',
      :user => 'root',
      :protocol => 'tcp',
      :source => ['0.0.0.0/0'],
      :dport => '22'
    }
#  '<rule name>' =>
#     :direction => '<in|out>',
#     :protocol => '<udp|tcp|icmp>',
#     :user => '<local user from /etc/passwd>',
#     :interface => '<default|all|eth0|eth1|br0|...>',
#     :source => '<ip|fqdn|chef search>|['<ip|fqdn|chef search>',...]'>',
#     :sport => '<integer(:integer))>',
#     :destination => '<ip|fqdn|chef search>|['<ip|fqdn|chef search>',...]'>',
#     :dport => '<integer(:integer)>',
#     :env => '<production|staging|...>',
#     :options => ['disable_env_limit', 'disable_syntax_check', ...]
}

