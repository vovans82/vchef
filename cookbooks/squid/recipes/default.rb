#
# Cookbook Name:: squid
# Recipe:: default
#
# MIT License
# 

package "squid" do
  package_name 'squid'
  action :install
end

service "squid" do
  action :start
  enabled true
  supports [:start, :restart, :stop]
end

template "/etc/squid/squid.conf" do
  action :create
  source "squid.conf"
  owner 'root'
  group 'root'
  mode "0744"
  notifies :restart, resources(:service => "squid"), :immediate
end
