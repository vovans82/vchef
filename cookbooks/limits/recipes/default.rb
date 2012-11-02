#
# Cookbook Name:: limits
# Recipe:: default
#
# Copyright 2011, ChooChee, Inc.
#
# All rights reserved - Do Not Redistribute
#

template "/etc/security/limits.conf" do
  source "limits.conf.erb"
  not_if "grep 'gas mask' /etc/security/limits.conf"
end
