## USER CASES ##

* A User can create an account.
* A User can sign in to an existing account.
* A User can search for recipes by ingredient.
* A User can save favorite recipes.
* A User can receive a random recipe from the database if they don't know what to eat.
* A User can generate a shopping list of needed ingredients based on a single saved recipe.
* A User can generate a shopping list of needed ingredients based on all saved recipe.


## PROGRAM FLOW ##

* CLI app displays logo and welcome message
* User is asked whether they want to make a create a new account or sign in to existing account
    - Create new account
        - User enters username, first name, and password
        - Program checks to see if username is already taken, and repeats prompt if unavailable
    - Sign in to existing account
        - User enters username and password
        - Program finds user instance, repeats prompt if not found
* Menu of options displayed
    - Menu displays after each completed action
        - Search for recipe by ingredient
            - User enters a recipe name
            - Program finds all recipes that include the user's ingredient and displays list
            - User is given the option to save a recipe from the list to their saved recipes
        - Fetch my recipes
            - Displays list of user's saved recipes
        - I don't know what to eat
            - Displays a random recipe
            - User is given the option to save the recipe to their saved recipes
        - Make a shopping list for one saved recipe
            - User selects a recipe from their list of saved recipes
            - Program finds recipe by recipe title and returns a list of that recipe's ingredients
        - Make a shopping list for all saved recipes
            - Displays list of all ingredients for all of user's saved recipes
