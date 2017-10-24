# require_relative './question.rb'
require 'pry'

class User
  attr_accessor :user_name, :scores, :high_score
  @@all = []

  def initialize(user_name)
    @user_name = user_name
    @scores = []
    @high_score = scores.max
  end

end


def find_or_create_user
  puts "Are you a new user or returning?"
  answer = get_user_input

  if answer == "new"

  elsif answer == "returning"
    

end

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


def filter
  loop do
    single_question = Question.find(rand(1..99))
    unless single_question["question"] == "" || iterate_symbols(single_question["answer"]) || single_question["value_id"] != 1
      return single_question
      break
    end
  end
end


def iterate_symbols(singleQuestion)
  symbols = ";:.>,</?!@#$%^&*}{+=-_~`[]|'".split("")
  symbols.each do |ele|
    if singleQuestion.include?(ele)
      return true
    end
  end
  return false
end



# def ask_question
#   thing = Question.all.sample
#   puts question = thing["question"]
#   answer = thing["answer"]
#   user_answer = get_user_input
#   if user_answer.downcase == answer.downcase
#     puts "Correct!"
#     winnings += thing.value.value
#   else
#     puts "Wrong!"
#   end
#   winnings
# end

def ask_question
  winnings = 0
  thing = filter
  puts question = thing["question"]
  answer = thing["answer"]
  user_answer = get_user_input
  if user_answer.downcase == answer.downcase
    winnings += thing.value.value
    puts "Correct!
    "
  else
    puts "Wrong! The correct answer is #{answer}.
    "
  end
  winnings
end


def player
  tot_winnings = 0
  counter = 0
  while counter < 5
    winnings = ask_question
    tot_winnings += winnings
    counter += 1
  end
  tot_winnings
  puts "Your winnings add up to $#{tot_winnings}"
end



def prompt_user
  puts "Would you like to play another round? Please type 'yes' or 'no'"
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
