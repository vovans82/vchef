cron 'Compact Chef DB' do
  user 'root'
  hour '1'
  minute '0'
  command 'curl -H "Content-Type: application/json" -X POST http://localhost:5984/chef/_compact > /dev/null 2>&1'
end

cron 'Compact Chef Views' do
  user 'root'
  hour '1'
  minute '30'
  command 'bash -c \'for x in checksums clients cookbooks data_bags environments id_map nodes roles sandboxes users; do curl -H "Content-Type: application/json" -X POST http://localhost:5984/chef/_compact/$x ; done\' > /dev/null 2>&1'
end

cron 'Chef Server backup' do
  user 'root'
  hour '4'
  minute '0'
  command '/root/scripts/chef_server_backup.sh > /dev/null 2>&1'
  only_if  { File.exist?("/root/scripts/chef_server_backup.sh") }
end

cron 'Clean-up solr logs older than 7 days' do
  user 'root'
  hour '3'
  minute '0'
  command 'find /var/lib/chef/solr/jetty/logs/* -mtime +7 -exec rm {} \;'
end

cron 'Chef Server restore' do
  user 'root'
  hour '5'
  minute '0'
  command '/root/scripts/chef_server_restore_from_backup.sh > /dev/null 2>&1'
  only_if { node['fqdn'] == "chef001.lon1.inf.choochee.com" && File.exist?("/root/scripts/chef_server_restore_from_backup.sh") }
end
