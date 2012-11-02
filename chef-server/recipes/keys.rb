cookbook_file "/etc/chef/validation.pem" do
  mode "644"
  owner "chef"
  group "chef"
  notifies :restart, resources(:service => "chef-server")
end

cookbook_file "/etc/chef/webui.pem" do
  mode "600"
  owner "chef"
  group "chef"
  notifies :restart, resources(:service => "chef-server")
end

cookbook_file "/etc/chef/certificates/cert.pem" do
  mode "644"
  owner "root"
  group "root"
  notifies :restart, resources(:service => "chef-server")
end

cookbook_file "/etc/chef/certificates/key.pem" do
  mode "600"
  owner "chef"
  group "chef"
  notifies :restart, resources(:service => "chef-server")
end

