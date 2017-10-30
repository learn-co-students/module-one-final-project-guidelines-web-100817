require_relative '../config/environment'
require_relative '../lib/api_communicator'
require_relative '../lib/cli'
require 'asciiart'
require 'tty-prompt'





    recipe_hound
    sleep(0.5)
    welcome_image
    sleep(0.5)
    welcome_message
    sleep(0.5)
    user = create_new_account_or_login_prompt
    100.times do
      prompt_menu(user)
    end
