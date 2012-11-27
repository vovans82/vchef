#
# Cookbook Name:: basics
# Recipe:: default
#
# Copyright 2010, 2600hz, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
directory "/root/scripts" do
  owner "root"
  group "root"
  mode "0755"
  recursive true
  action :create
end

if node[:platform] == "ubuntu"
packages = %w[
	dstat dnsutils gdb htop lsof mlocate screen socat strace telnet traceroute
]
else
packages = %w[
	dstat bind-utils gdb htop lsof mlocate screen socat strace telnet traceroute vim-enhanced
]
end

if node[:app_environment] != "prod" || node[:app_environment] != "inf"
  packages << "wireshark"
  packages << "gdb"
end


packages.each do |pkg|
	package pkg
end

# Install the RPM faking utility Alien for ubuntu systems
if node[:platform] == "ubuntu"
  package "alien"
end

template "/etc/rc.d/rc.local" do
  source "rc.local.erb"
  owner "root"
  group "root"
  mode 0755
  not_if { node[:platform] == "ubuntu" || node[:platform] == "amazon" }
end

cookbook_file "/etc/profile.d/appdirect.sh" do
  source "appdirect.sh"
  mode 0755
  owner "root"
  group "root"
end

#template "/etc/profile.d/appdirect.sh" do
#  source "appdirect.sh.erb"
#  owner "root"
#  group "root"
#  mode "0755"
#  ignore_failure true
#  not_if { node[:platform] == "ubuntu" }
#end

file "/etc/chef/first-boot.json" do
  action :delete
end

