nodes.all do |n|
  puts "#{n.name}: #{n[:recipes].join(',')}"
end
