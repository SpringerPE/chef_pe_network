# pe_network-cookbook

Cookbook to control network devices, physical mappings, internet addresses and firewall 
rules on a server. It can read all the attributes from a databag.

Warning, For the moment, this cookbook does not control the GW!

## Supported Platforms

 * Debian
 * Ubuntu
 * Centos

## Attributes

To can define the attributes, or use a databag to read and setup all of them.
For instance, here you see the attribute file of this cookbook:

```
### Main databag attributes
default[:pe_network][:data_bag] = 'network'
default[:pe_network][:bag_name] = node[:hostname]
default[:pe_network][:environment] = node[:chef_environment] ? node[:chef_environment] : "_default"

### Network Definitions
default[:pe_network][:udev] = "/etc/udev/rules.d/70-persistent-net.rules"
default[:pe_network][:network] = {
#   '192.168.1.2' => {
#      :device => "eth2",
#      :network => "192.168.1.0",
#      :mask => "255.255.255.0",
#      :mac => "08:00:27:84:ee:e7",
#      :mtu => "1400",
#      :bcast => "192.168.1.255"
#  }
}

### Firewall
default[:pe_network][:firewall][:enabled] = false
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
```
All the default value of the attributes are safe and the best way to define the 
parameters is using a databag.


## Usage

The easy way is just use a databag to define the device mappings, ips and firewall rules. 
Be carefull defining the rules on the primary interface ... you can lost the connectivity 
in the middle of the chef convergence. So, you have to create a databag named `network` 
with a file named equal as the node's name. In that file you can define all the attributes 
in json format, for example:

```json
{
    "id": "pe-network-berkshelf",
    "_default": {
        "network": {
           "192.168.1.2": {
               "device": "eth2",
               "mac": "08:00:27:84:ee:e7",
               "mtu": "1400"
           }
        },
        "firewall": {
            "enabled": true,
            "enable_input_drop": true,
            "enable_output_drop": false,
            "rules": {
                "allow ssh": {
                    "direction": "in",
                    "user": "root",
                    "protocol": "tcp",
                    "source": ["0.0.0.0/0"],
                    "dport": "22"
                },
                "allow web": {
                    "direction": "in",
                    "user": "root",
                    "protocol": "tcp",
                    "source": ["0.0.0.0/0"],
                    "dport": "80"
                }
        }
    }
}
```

The configuration is pretty easy to understand. There are two parts, the first part `network` 
is to define the ifconfig parameters (it also supports Centos and RH):

 * `device` is the only mandatory attribute, the cookbook will assign the IP to it.
 * If there is a `mac`, it will change or create the udev rules to assure the mapping (even if the mac is not found).
 * You can define other attributes like:
     * `mtu`  
     * `network`
     * `mask`
     * `bcast` 

In the second part you can define all the firewall rules. You can use chef searchs in the source and destination attributes :

 * 'rule name' =>
     * `direction` => '<in|out>'  (*mandatory*)
     * `protocol` => '<udp|tcp|icmp>' (*mandatory*)
     * `user` => '<local user from /etc/passwd>' (*mandatory*)
     * `interface` => '<default|all|eth0|eth1|br0|...>'
     * `source` => '<ip|fqdn|chef search>|['<ip|fqdn|chef search>',...]'>' (*mandatory for `in` rules*)
     * `sport` => '<integer(:integer))>'
     * `destination` => '<ip|fqdn|chef search>|['<ip|fqdn|chef search>',...]'>' (*mandatory for `out` rules*)
     * `dport` => '<integer(:integer)>'
     * `env` => '<production|staging|...>',
     * `options` => ['disable_env_limit', 'disable_syntax_check', ...]

You can use chef searchs in the source and destination attributes. More info in the
AFW's home site: https://github.com/jvehent/AFW

To apply the cookbook just include `pe_network` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[pe_network::default]"
  ]
}
```

## License and Authors

Author:: Jose Riguera Lopez, Springer SBM (<jose.riguera@springer.com>)
