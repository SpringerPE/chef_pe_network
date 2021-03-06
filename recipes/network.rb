#
# Cookbook Name:: pe_network
# Recipe:: network
#
# Copyright (C) 2014 Jose Riguera, Springer SBM
# 

class ::Chef::Recipe
  include SPRpe
end
Chef::Resource::RubyBlock.send(:include, SPRpe)

udev = node[:pe_network][:udev]
networks = node[:pe_network][:network]
begin
   networks.each_pair do |device, parameters|
      # Process the settings
      if parameters[:mac]
         mac = parameters[:mac]
         dev = dev_addr(mac)
         Chef::Log.info("Current device for #{mac}: #{dev}")
         if !(device && device == dev)
            device = device ? device : dev            
            ruby_block "update_udev" do
               block do
                  net_udev(mac, device, true, udev)
               end
            end
         end
      end
      ip = parameters[:ip] ? parameters[:ip] : nil
      if ip
         Chef::Log.info("Setting '#{ip}' on '#{device}'")
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
            target ip
            network parameters[:network] ? parameters[:network] : nil
            mtu parameters[:mtu] ? parameters[:mtu] : nil
            mask parameters[:mask] ? parameters[:mask] : nil
            bcast parameters[:bcast] ? parameters[:bcast] : nil
            onboot parameters[:onboot] ? parameters[:onboot] : nil
            action :add
            #notifies :restart, "service[networking]", :delayed
         end
      end
   end
rescue
   Chef::Log.fatal("Processing network")
end

#service "networking" do
#   service_name "networking"
#   action :restart
#end

