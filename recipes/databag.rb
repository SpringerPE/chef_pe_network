#
# Cookbook Name:: pe_network
# Recipe:: databag
#
# Copyright (C) 2014 Jose Riguera, Springer SBM
# 

class ::Chef::Recipe
  include SPRpe
end

if node[:pe_network][:bag_name]
  begin
    databag = node[:pe_network][:data_bag]
    bagname = node[:pe_network][:bag_name]
    environment = node[:pe_network][:environment]
    set_databag('pe_network', databag, bagname, environment)
  rescue
    Chef::Application.fatal!('Something was wrong while processing data_bag!', 1)
  end
end

