#
# Cookbook Name:: pe_network
# Recipe:: databag
#
# Copyright (C) 2014 Springer
# 

class ::Chef::Recipe
  include SPRpe
end

begin
  databag = node[:pe_network][:data_bag]
  bagname = node[:pe_network][:bag_name]
  environment = node[:pe_network][:environment]
  set_databag(databag, bagname, environment)
rescue
  Chef::Application.fatal!('Something was wrong while processing data_bag!', 1)
end

