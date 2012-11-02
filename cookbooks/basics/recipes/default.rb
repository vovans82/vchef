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

template "/root/scripts/mysql_server_backup.sh" do
        source "mysql_server_backup.sh"
        owner "root"
        group "root"
        mode 0744
end

if node[:fqdn] == "pmm001.rs116.prod.choochee.com" || node[:fqdn] == "pmm001.lon343.prod.choochee.com"
        cron "mysql_server_backup" do
                command "/root/scripts/mysql_server_backup.sh > /dev/null 2>&1"
                minute "00"
                hour "01"
        end
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

###Chef::Log.info("PLATFORM:"+node[:platform]+":PLATFORM")

###if node[:cloud] != nil && node[:platform] != "amazon"
cookbook_file "/usr/local/bin/wm_gw.sh" do
  source "wm_gw.sh"
  mode   "0647"

end



if node[:location] == "LON"
	cookbook_file "/usr/local/bin/gw.txt" do
  		source "LON_gateways.txt"
  		mode "0644"
	end
else 
	if node[:app_environment]  == "prod" || node[:app_environment] == "beta"
  		cookbook_file "/usr/local/bin/gw.txt" do
               	 	source "ORD1_gatways.txt"
              	  	mode "0644"
        	end
	else 
                cookbook_file "/usr/local/bin/gw.txt" do
                        source "ORD_N_gatways.txt"
                        mode "0644"
                end
	end
end

if node.roles.include?("gateway") || node.roles.include?("global_proxy")
Chef::Log.info "I don't need wm_gw.sh script run"
else
	execute "wm_gw.sh" do
    	command "/usr/local/bin/wm_gw.sh"
    	action :run
	end
end

if node[:platform] == "amazon"
  execute "install git" do
    command "yum install git --disablerepo=choochee-custom"
    action :run
  end
end

template "/etc/rc.d/rc.local" do
  source "rc.local.erb"
  owner "root"
  group "root"
  mode 0755
  not_if { node[:platform] == "ubuntu" || node[:platform] == "amazon" }
end

template "/etc/profile.d/choochee.sh" do
  source "choochee.sh.erb"
  owner "root"
  group "root"
  mode "0755"
  ignore_failure true
  not_if { node[:platform] == "ubuntu" }
end

file "/etc/chef/first-boot.json" do
  action :delete
end

