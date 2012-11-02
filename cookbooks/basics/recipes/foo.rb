new_hostname = "#{node.name}".split(".").first
new_fqdn = "#{new_hostname}.#{node[:deployment_id]}.#{node[:app_environment]}.choochee.com"

ruby_block "edit etc hosts" do
  block do
    rc = Chef::Util::FileEdit.new("/etc/hosts")
    rc.search_file_replace_line(/^127\.0\.0\.1/, "127.0.0.1 #{new_fqdn} #{new_hostname} localhost")
    rc.write_file
  end
end

execute "hostname --file /etc/hostname" do
  action :nothing
end

file "/etc/hostname" do
  content "#{new_hostname}"
  notifies :run, resources(:execute => "hostname --file /etc/hostname"), :immediately
end

node.automatic_attrs["hostname"] = new_hostname
node.automatic_attrs["fqdn"] = new_fqdn
