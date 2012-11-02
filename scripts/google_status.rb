require 'google_spreadsheet'
 
session = GoogleSpreadsheet.login ENV["GOOGLE_EMAIL"], ENV["GOOGLE_PASSWORD"]

puts "Logged in"

sheet = session.create_spreadsheet "Instances #{Time.now.strftime "%Y%m%d"}"

puts "Created spreedsheet"
 
ws = sheet.worksheets.first

puts "Using first sheet"
 
ws[1,1] = "Check In"
ws[1,2] = "Node Name"
ws[1,3] = "Ruby Version"
ws[1,4] = "Recipes"

puts "Headers added"
 
i = 2
nodes.all do |n|
  ws[i,1] = Time.at(n['ohai_time']).strftime("%F %R")
  ws[i,2] = n.name
  ws[i,3] = n['languages']['ruby']['version']
  ws[i,4] = n.run_list.expand.recipes.join(", ")
  puts "Added #{n.name}"
  i = i + 1
end

puts "Saving file"
ws.save
puts "File saved"

