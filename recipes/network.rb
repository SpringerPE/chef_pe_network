#
# Cookbook Name:: pe_network
# Recipe:: network
#
# Copyright (C) 2014 Springer
# 

class ::Chef::Recipe
  include SPRpe
end
Chef::Resource::RubyBlock.send(:include, SPRpe)

udev = node[:pe_network][:udev]
networks = node[:pe_network][:server]
begin
   networks.each_pair do |ip, parameters|
      # Process the settings
      device = parameters[:device] ? parameters[:device] : nil
      if parameters[:mac]
         mac = parameters[:mac]
         dev = dev_addr(mac)
         Chef::Log.info("Current device for #{mac}: #{dev}")
         if !(device && device == dev)
            ruby_block "update_udev" do
               block do
                  device = device ? device : dev
                  net_udev(mac, device, true, udev)
               end
            end
         end
      end
      Chef::Log.fatal("No device defined for '#{ip}'!") if !device
      # Set the IP for each device
      ifconfig device do
         ignore_failure true
  	 device device
         action :delete
         notifies :add, "ifconfig[#{ip}]", :immediately
      end
      ifconfig ip do
         ignore_failure false
  	 device device
         inet_addr ip
         network parameters[:network] ? parameters[:network] : nil
         mtu parameters[:mtu] ? parameters[:mtu] : nil
         mask parameters[:mask] ? parameters[:mask] : nil
         bcast parameters[:bcast] ? parameters[:bcast] : nil
         action :add
         #notifies :restart, "service[networking]", :delayed
      end
   end
rescue
   Chef::Log.fatal("Processing network")
end

#service "networking" do
#   service_name "networking"
#   action :restart
#end







