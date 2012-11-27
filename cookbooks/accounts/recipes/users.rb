#
# Cookbook Name:: accounts
# Recipe:: users
#
# Copyright 2012, 2600hz Inc
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

if node['languages']['ruby']['version'] != "1.8.6"
  if node['languages']['ruby']['version'] != "1.8.7"
    g = gem_package "ruby-shadow" do
      action :nothing
    end
    g.run_action(:install)
    Gem.clear_paths
  end
end

# remove the bootstrap user
user("bootstrap") do
  action :remove
  # don't try to run if bootstrap is still logged in
  not_if "who | grep bootstrap"
end

# create users from the users databag
search( "users" ).sort_by {|u| u[:uid] }.each do |user|
  if node['roles'].include? "builder-slave"
    user user[:id] do
    action :remove
  end
  next
  end unless %w[ vsmirnov pmcbride root ].include? user[:id]

  if user[ :home ] != false
    homedir = user[ :home ] || "/home/#{user[:id]}"
  end

  user user[:id] do
    comment  user[ :name     ]
    uid      user[ :uid      ]
    shell    user[ :shell    ] || "/bin/bash"
    password user[ :password ] || "$1$oBTQd/WJ$UBd0XfleEOk3.ZGZF9Ue30"
    if user[ :home ] != false
      home     homedir
    end
    supports :manage_home => true
    action [ :create, :manage ]
  end

  if user[ :home ] != false
    directory homedir + "/.ssh" do
      owner user[:id]
      group user[:gid]
      mode  0700
    end

    template homedir + "/.ssh/authorized_keys" do
      owner user[:id]
      group user[:gid]
      mode  0644
      variables( :keys => user[:ssh_keys] )
    end
	
    if user[:ssh_private_key_file] 
      cookbook_file "/home/#{user[:id]}/.ssh/id_rsa" do
           source "#{user[:ssh_private_key_file]}"
           mode "0600"
           owner user[:id] 
           group user[:gid]
        end
    end

  end
end


#user "root" do
#  password ""
#  action :lock
#end

# removing old users
#%w{sharon igor olga timur amrapali slum alabara akraut}.each do |del_user|
#  user "#{del_user}" do
#    action :remove
#    ignore_failure true
#  end
#end
