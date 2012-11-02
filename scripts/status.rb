printf "%-20s %-12s %-8s %s\n", "Check In", "Name", "Ruby", "Recipes"
nodes.all do |n|
  checkin = Time.at(n['ohai_time']).strftime("%F %R")
  rubyver = n['languages']['ruby']['version']
  recipes = n.run_list.expand.recipes.join(", ")
  printf "%-20s %-12s %-8s %s\n", checkin, n.name, rubyver, recipes
end
