require_relative "../config/environment.rb"

Ingredient.delete_all
RecipeIngredient.delete_all
Recipe.delete_all
User.delete_all
UserRecipe.delete_all

array_of_hashes = get_all_recipes

array_of_hashes.each do |recipe|
  new_recipe = Recipe.find_or_create_by(title: recipe["title"], href: recipe["href"]) #creates all recipes
  ###
  recipe["ingredients"] = recipe["ingredients"].split(", ") #turns the ingredients string into an array of ingredients
  recipe["ingredients"].each do |ingredient|
    new_ingredient = Ingredient.find_or_create_by(title: ingredient) #creates all ingredients
    RecipeIngredient.create(recipe: new_recipe, ingredient:new_ingredient) #associates new_recipe and new_ingredient as a new instance in RecipeIngredient
  end
end
