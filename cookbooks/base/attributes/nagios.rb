##default[:nagios] ||= Hash.new
##default[:nagios][:services] ||= Hash.new
##default[:nagios][:services][:base] ||= Hash.new
##default[:nagios][:services][:base][:freespace] = { :description => "Free Space", :command => "check_all_disks" }
##default[:nagios][:services][:base][:loadaverage] = { :description => "Load Average", :command => "check_nrpe_load" }
##default[:nagios][:services][:base][:freememory] = { :description => "Free Memory", :command => "check_nrpe_mem" }
##default[:nagios][:services][:base][:ssh] = { :description => "SSH", :command => "check_nrpe_ssh" }
##default[:nagios][:services][:base][:ping] = [ "Ping", "check_ping!500,20%!1000,80%" ]
##default[:nagios][:services][:base][:postfix] = { :description => "Postfix", :command => "check_process_postfix" }
