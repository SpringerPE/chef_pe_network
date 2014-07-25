#
# Cookbook Name:: pe_network
# Recipe:: firewall
#
# Copyright (C) 2014 Jose Riguera, Springer SBM
# 

class ::Chef::Recipe
  include SPRpe
  include AFW
end

# enable or disable the firewall restore command. If set the false, 
# the rules will still be populated in /etc/firewall/rules.iptables 
# but the restore command will not be issued.
node.override[:afw][:enable] = node[:pe_network][:firewall][:enabled]
node.override[:afw][:enable_input_drop] = node[:pe_network][:firewall][:enable_input_drop]
node.override[:afw][:enable_output_drop] = node[:pe_network][:firewall][:enable_output_drop]
node.override[:afw][:enable_input_drop_log] = node[:pe_network][:firewall][:log]
node.override[:afw][:enable_output_drop_log] = node[:pe_network][:firewall][:log]

# Include the recipe to create the default configuration
include_recipe 'afw::default'

fw = node[:pe_network][:firewall][:rules]
begin
   fw.each_pair do |rule, parameters|
      # Process the settings
      # Call the AFW module to create the rule
      AFW.create_rule(node, rule, parameters)
   end
rescue
   Chef::Log.fatal("Processing firewall rules")
end

