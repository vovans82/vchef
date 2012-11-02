#
# Cookbook Name:: selinux
# Recipe:: default
#
# Copyright 2010, ChooChee Inc.
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

execute "disable_selinux" do
  command "echo 0 > /selinux/enforce"
  action :nothing
  ignore_failure true
  only_if { node['cloud'] == nil }
end

directory "/etc/selinux" do
  owner "root"
  group "root"
  action :create
end

template "/etc/selinux/config" do
  source "config.erb"
  owner "root"
  group "root"
  variables(
    :selinux => node['selinux']['status'],
    :selinuxtype => node['selinux']['type'],
    :local_def => node['selinux']['local_def']
  )
  notifies :run, resources(:execute => "disable_selinux"), :immediately
  only_if { node['cloud'] == nil }
end
