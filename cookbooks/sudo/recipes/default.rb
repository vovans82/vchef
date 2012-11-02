#
# Cookbook Name:: sudo
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

package("sudo") { action :upgrade }

template "/etc/sudoers" do
  owner "root"
  group "root"
  mode  0440
end

#sudosh2_version="sudosh2-1.0.4"

#script "sudosh2" do
#    not_if {FileTest.exists?("/usr/local/bin/sudosh")}
#    interpreter "bash"
#    user "root"
#    cwd "/root"
#    code <<-EOF
#    cd /root
#    wget http://repo.choochee.com/archive/sudosh2-1.0.4.tbz2 -O #{sudosh2_version}.tbz2
#    tar xjvf #{sudosh2_version}.tbz2
#    cd #{sudosh2_version}
#    ./configure | tee configure.out
#    make && make install | tee make.out
#    EOF
#end

package "sudosh2" do
    action :install
    not_if ("rpm -q sudosh2")
    ignore_failure true
end
