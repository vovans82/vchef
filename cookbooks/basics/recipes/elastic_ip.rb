
if node.name == "qatest001.rsord259.perf"
  node[:elastic_ip] = "50.57.192.150"
elsif node.name  == "qatest002.rsord259.perf"
  node[:elastic_ip] = "107.22.195.100"
elsif node.name == "qatest003.rsord259.perf"
  node[:elastic_ip] = "107.22.251.16"
elsif node.name == "backup001.rs1.inf"
  node[:elastic_ip] = "50.19.220.89"
end

node.save
