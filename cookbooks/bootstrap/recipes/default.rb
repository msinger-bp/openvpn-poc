node['bootstrap']['recipe_list'].each do |r|
  include_recipe r
end


