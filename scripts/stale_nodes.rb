# returns a list of nodes that have
# checked-in within the last MINUTES
 
abort("usage: knife exec stale_nodes.knife MINUTES") unless ARGV[2]
mintues_ago = ARGV[2].to_i
stale_nodes = search(:node, '*:*').select{|n| n.attribute?('ohai_time') && (n.ohai_time < (Time.now - mintues_ago*60).to_f)}
 
# sort the list by checkin time
stale_nodes.sort!{|r1,r2| r1.ohai_time <=> r2.ohai_time}
 
printf "%-30s %-40s %-30s\n", "Last Checkin", "Host", "Run List"
stale_nodes.each do |n|
  printf "%-30s %-40s %-30s\n", Time.at(n.ohai_time), n.name, n.run_list.sort{|r1,r2| r1.name <=> r2.name}
end
 
# Prevents knife from trying to execute any command line arguments as addtional script files, see CHEF-1973
exit 0

