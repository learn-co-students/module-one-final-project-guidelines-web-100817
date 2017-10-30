require 'pry'
require 'tty-prompt'
require 'asciiart'


## ===== WELCOME METHODS ===== ##

def recipe_hound
  puts "\e[96m
  8888888b.                    d8b                   888    888                                 888
  888   Y88b                   Y8P                   888    888                                 888
  888    888                                         888    888                                 888
  888   d88P  .d88b.   .d8888b 888 88888b.   .d88b.  8888888888  .d88b.  888  888 88888b.   .d88888
  8888888P   d8P  Y8b d88P     888 888  88b d8P  Y8b 888    888 d88  88b 888  888 888  88b d88  888
  888 T88b   88888888 888      888 888  888 88888888 888    888 888  888 888  888 888  888 888  888
  888  T88b  Y8b.     Y88b.    888 888 d88P Y8b.     888    888 Y88..88P Y88b 888 888  888 Y88b 888
  888   T88b  Y888888  Y8888P8 888 88888P    Y888888 888    888  Y8888P   Y888888 888  888  Y888888
                                   888
                                   888
                                   888
                                   888
  \e[0m"
end

def welcome_image # => displays welcome ascii image
  ascii = AsciiArt.new("https://s7d2.scene7.com/is/image/PetSmart/PB1201_STORY_CARO-Authority-HealthyOutside-DOG-20160818?$PB1201$")
  print ascii.to_ascii_art
end


def welcome_message # => greets user at the start of the program
  puts "\n\e[96mWelcome to \e[0m\e[1mRecipeHound\e[0m\e[96m, the CLI app that sniffs out the perfect recipe for you!\e[0m"
  puts "\n\e[96mWith \e[0m\e[1mRecipeHound\e[0m\e[96m, you can:
    - fetch and save recipes based on ingredients you have on hand
    - print a list of all your saved recipes
    - print a shopping list of the items you need for your recipe(s)
    - get a recipe suggestion if you're feeling indecisive or uninspired\e[0m"
  border
end


def create_new_account_or_login_prompt  # => asks user to sign in or create a new account
  login = TTY::Prompt.new
  login_options = ["\e[93mCreate a new account\e[0m", "\e[93mSign in with an existing account\e[0m"]
  login_selection = login.select("\n\e[95mLet's get started! Would you like to create a new account or sign in to an existing account?\e[0m", login_options)
  if login_selection == "\e[93mCreate a new account\e[0m"
    user = create_new_user_account
  else login_selection == "\e[93mSign in with an existing account\e[0m"
    puts "\n\e[95mPlease enter your username.\e[0m"
    user_username = gets.chomp
    password = TTY::Prompt.new
    user_password = password.mask("\e[95mPlease enter your password.\e[0m")
    user = User.find_by(username: user_username, password: user_password)
    if user == nil
      puts "\n\e[91mRuh roh! No user found with that username and password. Please try again.\e[0m"
      create_new_account_or_login_prompt
    else
      user = User.find_by(username: user_username, password: user_password)
      puts "\n\e[93mHello, #{user.first_name}. Welcome back!\e[0m"
      user
    end
  end
end
#
# def existing_account_login  # => finds existing user
#   puts "\n\e[95mPlease enter your username.\e[0m"
#   user_username = gets.chomp
#   password = TTY::Prompt.new
#   user_password = password.mask("\e[95mPlease enter your password.\e[0m")
#   user = User.find_by(username: user_username, password: user_password)
#   if user == nil
#     puts "\n\e[91mRuh roh! No user found with that username and password. Please try again.\e[0m"
#     create_new_account_or_login_prompt
#     binding.pry
#   else
#     user = User.find_by(username: user_username, password: user_password)
#     puts "\n\e[93mHello, #{user.first_name}. Welcome back!\e[0m"
#   end
# user
# end



def create_new_user_account # => takes user inputs and creates a new User instance
  puts "\n\e[95mWhat would you like your username to be?\e[0m"
  user_username_input = gets.chomp
  user = User.find_by(username: user_username_input)
  if user == nil
    puts "\e[95mI like that. What's your first name?\e[0m"
    user_first_name = gets.chomp
    password = TTY::Prompt.new
    user_password = password.mask("\e[95mGot it. Choose a password. Make sure you save it in a safe place!\e[0m")
    puts "\n\e[93mYou're all set up, #{user_first_name}! Your username is #{user_username_input}.\e[0m"
    user = User.create(first_name: user_first_name, username: user_username_input, password: user_password)
  else
    puts "\n\e[91mSorry, that username is already taken.\e[0m"
    create_new_user_account
  end
  user
end


def existing_account_login  # => finds existing user
  puts "\n\e[95mPlease enter your username.\e[0m"
  user_username = gets.chomp
  password = TTY::Prompt.new
  user_password = password.mask("\e[95mPlease enter your password.\e[0m")
  user = User.find_by(username: user_username, password: user_password)
  if user == nil
    puts "\n\e[91mRuh roh! No user found with that username and password. Please try again.\e[0m"
    create_new_account_or_login_prompt
    binding.pry
  else
    user = User.find_by(username: user_username, password: user_password)
    puts "\n\e[93mHello, #{user.first_name}. Welcome back!\e[0m"
  end
user
end
clear


## ===== MENU ===== ##

def border
  puts "
  <<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>>"
end

def prompt_menu(user)
  border
  menu = TTY::Prompt.new
  menu_options = ["\e[93mSearch for a recipe by ingredient\e[0m", "\e[93mFetch my recipes\e[0m", "\e[93mI don't know what to eat\e[0m", "\e[93mMake a shopping list for one saved recipe\e[0m", "\e[93mMake a shopping list for all saved recipes\e[0m"]
  user_selection = menu.select("\n\e[95mWhat would you like to do?\e[0m", menu_options)
  user_selection
  if user_selection == "\e[93mSearch for a recipe by ingredient\e[0m"
    find_recipe_by_ingredient(user)
  elsif user_selection == "\e[93mFetch my recipes\e[0m"
    fetch_user_recipes(user)
  elsif user_selection == "\e[93mI don't know what to eat\e[0m"
    random_recipe(user)
  elsif user_selection == "\e[93mMake a shopping list for one saved recipe\e[0m"
    shopping_list_one_recipe(user)
  else user_selection == "\e[93mMake a shopping list for all saved recipes\e[0m"
    shopping_list_all_recipes(user)
  end
end


def find_recipe_by_ingredient(user)
  puts "\n\e[95mWhat ingredient would you like to use?\e[0m"
  user_ingredient = gets.chomp
  ingredient_given = Ingredient.find_by(title: user_ingredient) # => find the ingredient inputed
  if ingredient_given == nil # => if ingredient not found in db
    puts "\n\e[91mRuh roh! No recipes with that ingredient could be found. Try making it plural?\e[0m"
    find_recipe_by_ingredient(user)
  else # => if ingredient found in db
    relationships = RecipeIngredient.where(ingredient_id: ingredient_given.id) # => finds all relationships that contain that ingredient
    recipe_ids = relationships.collect {|row| row.recipe_id} # => collects all recipe_ids
    recipes = recipe_ids.collect {|id| Recipe.find(id) } # => collects all recipe objects
    puts "\n\e[95mHere are some available recipes with that ingredient:\e[0m"
    puts "\n\e[96mRecipes that use #{user_ingredient}:\e[0m"
    puts "-------------------------"
    recipes_results = recipes.each {|recipe| puts "#{recipe.title}" } # => displays title of each recipe
    recipes_results_by_title = recipes.collect {|recipe| recipe.title }
    save_recipe_prompt = TTY::Prompt.new
    should_i_save_recipe = save_recipe_prompt.select("\n\e[95mWould you like to save a recipe from this list?\e[0m", %w(Yes No))
      if should_i_save_recipe == "No"
        puts "\e[93mOkay, it won't be saved.\e[0m"
      else should_i_save_recipe == "Yes"
        save_recipe_from_list = TTY::Prompt.new
        user_selection = save_recipe_from_list.select("\e[95mWhich recipe would you like to save?\e[0m", recipes_results_by_title)
        saved_recipe = Recipe.find_by(title: user_selection)
        new_user_recipe = UserRecipe.create(recipe: saved_recipe, user: user)
        puts "\n\e[93mGreat! #{user_selection} has been saved to your list.\e[0m"
      end
  end
end


def fetch_user_recipes(user)
  relationships = UserRecipe.where(user_id: user.id) # => returns array of all relationships
  if relationships == []
    puts "\e[91mStop trying to make fetch happen. It's not going to happen. Try saving some recipes first.\e[0m"
    prompt_menu(user)
  else
    puts "\n\e[96mMy Recipes\e[0m"
    puts "-------------------------"
    recipe_ids = relationships.collect do |row| # => returns array of all recipe ids
      row.recipe_id
    end
    all_recipes = recipe_ids.collect do |x| # => returns array of all recipe objects
      puts Recipe.find(x).title
    end
  end
end


def random_recipe(user)
  puts "\n\e[95mWhy not try this recipe, #{user.first_name}?\e[0m"
  rand_recipe = Recipe.all.sample.title
  puts rand_recipe
  save_prompt = TTY::Prompt.new
  should_i_save = save_prompt.select("\n\e[95mWould you like to save it for later?\e[0m", %w(Yes No))
    if should_i_save == "No"
      puts "\n\e[93mOkay, it won't be saved.\e[0m"
    else should_i_save == "Yes"
      saved_recipe = Recipe.find_by(title: rand_recipe)
      new_user_recipe = UserRecipe.create(recipe: saved_recipe, user: user)
      puts "\n\e[93mGreat! #{rand_recipe} has been saved to your list.\e[0m"
    end
end


def shopping_list_all_recipes(user) # => returns all ingredients for entire cookbook
  relationships = UserRecipe.where(user_id: user.id) # => returns array of all relationships
  if relationships == []
    puts "\e[91mYour shopping list is empty. Save recipes before building a shopping list.\e[0m"
    prompt_menu(user)
  else
    puts "\n\e[96mShopping List\e[0m"
    puts "-------------------------"
    recipe_ids = relationships.collect do |row| # => returns array of all recipe ids
      row.recipe_id
    end
    all_recipes = recipe_ids.collect do |x| # => returns array of all recipe objects
      Recipe.find(x)
    end
    all_ingredients = all_recipes.collect do |recipe| # => returns array of all ingredient objects
      recipe.ingredients
    end.flatten.uniq
    shopping_list = all_ingredients.each do |ingredient|
      puts "#{ingredient.title}"
    end
  end
end

def shopping_list_one_recipe(user)
  relationships = UserRecipe.where(user_id: user.id) # => returns array of all relationships
  if relationships == []
    puts "\e[91mYour shopping list is empty. Save recipes before building a shopping list.\e[0m"
    prompt_menu(user)
  else
    recipe_ids = relationships.collect {|row| row.recipe_id } # => returns array of all recipe ids
    all_recipes = recipe_ids.collect {|x| Recipe.find(x) } # => returns array of all recipe objects
    recipe_titles = all_recipes.collect { |recipe| recipe.title} # => print out all saved recipe titles
    recipe_list = TTY::Prompt.new
    recipe_titles
    user_selection = recipe_list.select("\n\e[95mWhich saved recipe would you like to use?\e[0m", recipe_titles)
    puts "\n\e[96mShopping List\e[0m"
    puts "-------------------------"
    ingredients_list = Recipe.find_by(title: user_selection).ingredients.uniq.each {|ingredient| puts ingredient.title}
  end
  ingredients_list
end
