#
# Cookbook Name:: yumrepo
# Recipe:: ChooChee
#
# Copyright 2010, Harley Alaniz
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

if node[:platform] != "ubuntu"

  template "/etc/yum.conf" do
    mode "0644"
    source "yum.conf"
    group "root"
    owner "root"
    ignore_failure true
  end
 if node[:app_environment] == "ops" || node[:app_environment] == "staging" || node[:app_environment] == "qa" || node[:app_environment] == "preprod" || node[:app_environment] == "beta" || node[:app_environment] == "prod" || node[:app_environment] == "devinf"
	template "/etc/yum.repos.d/choochee.repo" do
		mode "0644"
		source "choochee_ops.repo.erb"
	end
 elsif node[:app_environment] == "inf" && node.roles.include?("global_proxy")
 template "/etc/yum.repos.d/choochee.repo" do
    mode "0644"
    source "choochee_global_inf.repo.erb"
  end
 elsif node[:app_environment] == "devinf" && node.roles.include?("global_proxy")
 template "/etc/yum.repos.d/choochee.repo" do
    mode "0644"
    source "choochee_global_devinf.repo.erb"
  end
 elsif node.roles.include?("backoffice")
 template "/etc/yum.repos.d/choochee.repo" do
    mode "0644"
    source "choochee_backoffice.repo.erb"
  end
 else
  template "/etc/yum.repos.d/choochee.repo" do
    mode "0644"
    source "choochee.repo.erb"
#    notifies :run, resources(:execute => "yum -y clean all"), :immediately
#    notifies :run, resources(:execute => "yum -y update"), :immediately
  end
end

 template "/etc/yum.repos.d/epel.repo" do
    mode "0644"
    source "epel.repo.erb"
#    notifies :run, resources(:execute => "yum -y clean all"), :immediately
#    notifies :run, resources(:execute => "yum -y update"), :immediately
  end
  execute "yum -y clean all" do
    action :run
  end
end
