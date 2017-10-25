# require_relative './question.rb'
require 'pry'


def find_or_create_user
  puts "Are you a new user or returning?"
  answer = get_user_input

  if answer == "new"
    puts "What would you like your username to be?"
    user_name = get_user_input
    the_user = User.find_or_create_by(user_name: user_name)

  elsif answer == "returning"
    puts "What is your username?"
    user_name = get_user_input
    the_user = User.find_or_create_by(user_name: user_name)
end

the_user
end

def welcome(the_user)
  puts "Welcome to Jeopardy, #{the_user.user_name}. My name is Alex Trebek.
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
  else
    invalid_command
    pick_your_path
  end
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
  symbols = ";:.>,</?!@#$%^&*}{+=-_~`[]|()'".split("")
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
  if "a #{user_answer.downcase}" == answer.downcase || user_answer.downcase == answer.downcase
    winnings += thing.value.value
    puts "\n Correct! \n"
  else
    puts "\n Wrong! The correct answer is #{answer}. \n"
  end
  winnings
end


def player
  puts "This...is...Jeopardy!"
  tot_winnings = 0
  counter = 0
  while counter < 5
    winnings = ask_question
    tot_winnings += winnings
    counter += 1
  end
  tot_winnings
  puts "Your winnings for this round add up to $#{tot_winnings}!"
end



def prompt_user
  puts "Would you like to play another round? Please type 'yes' or 'no'"
    answer = get_user_input
  if answer == "yes"
    player
  elsif answer == "no"
    puts "Thanks for playing!"
  else
    invalid_command
    prompt_user
  end
end


def count
  puts "In 1992, there were #{Question.all.count} questions asked."
end

def categoryReturn
  puts "These were all of the question categories in 1992:"
  puts Category.all.map{|cat| cat["name"]}
end

def weird
  newArr = [{Question.find(656)['question'] => Question.find(656)['answer']}, {Question.find(676)['question'] => Question.find(676)['answer']}, {Question.find(716)['question'] => Question.find(716)['answer']}]
  puts "This was an interesting question asked in 1992"
  puts newArr.sample
end

def trivia
  puts "What would you like to know? (select a number)"
  puts "1) Number of questions asked in 1992"
  puts "2) All of the categories from 1992"
  puts "3) Interesting question from 1992"
  trivia_runner
end

def invalid_command
  "Please enter a valid command"
end


# def give_trivia
#   if answer == "1"
#     count
#   elsif answer == "2"
#     categoryReturn
#   elsif answer == "3"
#     weird
#   else
#     puts "Please type a number"
#     trivia1
#   end
# end


def trivia_runner
  answer = get_user_input
  if answer == "1"
    count
  elsif answer == "2"
    categoryReturn
  elsif answer == "3"
    weird
  else
    puts "Please type a number"
    trivia
  end
  puts "Would you like to hear more trivia or play a round of Jeopardy? Please type 'trivia' or 'play'"
  response = get_user_input
  if response == 'play'
    player
  elsif response == 'trivia'
    trivia

  end

end

def invalid_command
  puts "Please enter a valid command"
end


def runner
  welcome(find_or_create_user)
  pick_your_path
  prompt_user
end
