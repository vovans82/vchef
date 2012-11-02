#
# Cookbook Name:: rabbitmq
# Recipe:: cluster
#
# Copyright 2009, Benjamin Black
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
include_recipe "rabbitmq::default"

nodes = search(:node, "role:ns AND role:inf")
node_list ||= []
nodes.each do |n|
  node_list << "'rabbit@#{n[:hostname]}-#{n[:deployment_id]}-#{n[:app_environment]}'"
end

bash "bootstrapped" do
  user "rabbitmq"
  code <<-EOH
  /etc/init.d/rabbitmq-server stop
  touch /var/lib/rabbitmq/.bootstrapped
  EOH
  not_if { File.exists? "/var/lib/rabbitmq/.bootstrapped" }
end

template "/etc/rabbitmq/rabbitmq.config" do
  source "rabbitmq.config.erb"
  owner "root"
  group "root"
  mode 0644
  variables ({
  	:node_list => node_list
  })
  notifies :restart, resources(:service => "rabbitmq-server")
end

unless node[:roles].include? "inf"
  bash "setup-cluster" do
  	code <<-EOH
  	rabbitmqctl stop_app
  	rabbitmqctl reset
  	rabbitmqctl cluster rabbit@#{nodes.first[:hostname]}-#{nodes.first[:deployment_id]}-#{nodes.first[:app_environment]}
  	rabbitmqctl start_app
  	EOH
  	not_if { File.exists? "/var/lib/rabbitmq/.bootstrapped" }
  end
end
