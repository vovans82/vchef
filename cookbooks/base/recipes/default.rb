#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2010, ChooChee, Inc.
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

node.default[:nagios][:services][:base][:freespace] = { :description => "Free Space", :command => "check_all_disks" }
node.default[:nagios][:services][:base][:loadaverage] = { :description => "Load Average", :command => "check_nrpe_load" }
node.default[:nagios][:services][:base][:freememory] = { :description => "Free Memory", :command => "check_nrpe_mem" }
node.default[:nagios][:services][:base][:ssh] = { :description => "SSH", :command => "check_nrpe_ssh" }
node.default[:nagios][:services][:base][:ping] = [ "Ping", "check_ping!500,20%!1000,80%" ]
node.default[:nagios][:services][:base][:postfix] = { :description => "Postfix", :command => "check_process_postfix" }

