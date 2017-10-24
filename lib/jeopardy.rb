require 'pry'
def welcome
  puts "Welcome to Jeopardy. My name is Alex Trebek.
        Would you like to play a round, or would you like to hear some trivia?
        Please enter 'play' or 'trivia'"
end

def get_user_input
  gets.chomp
end

def pick_your_path
  answer = get_user_input
  if answer == "play"
    player
  elsif answer == "trivia"
    trivia
  end
end

def trivia
  puts ""
end

def ask_question
  winnings = 0
  thing = Question.all[0]
  puts question = thing["question"]
  answer = thing["answer"]
  user_answer = get_user_input
  if user_answer.downcase == answer.downcase
    puts "Correct!"
    winnings += thing["value_id"]
  else
    puts "Wrong!"
  end
  winnings
end

def player

  counter = 0
  while counter < 5
    ask_question
    counter += 1
  end

end



def display_score(winnings)
  puts "Your winnings add up to $#{winnings}"
  score
end


def prompt_user
  puts "Would you like to play another round? Type 'yes' or 'no'"
    answer = get_user_input
  if answer == "yes"
    player
  elsif answer == "no"
    puts "Thanks for playing!"
  end
end

def runner
  welcome
  pick_your_path
  display_score
  prompt_user
end


# def initial_round
#   card_total = deal_card + deal_card
#   display_card_total(card_total)
# end
#
# def hit?(card_total)
#   prompt_user
#   answer = get_user_input
#   if answer == "h"
#     card_total += deal_card
#   elsif answer == "s"
#     card_total
#   else
#     invalid_command
#   end
#   card_total
# end
#
# def invalid_command
#   puts "Please enter a valid command"
# end

#####################################################
# get every test to pass before coding runner below #
#####################################################
# def runner
#   welcome
#   card_total = initial_round
#   until card_total > 21
#     card_total = hit?(card_total)
#     display_card_total(card_total)
#   end
# end_game(card_total)
# end
