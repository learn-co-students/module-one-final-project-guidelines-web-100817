# require_relative './question.rb'
require 'pry'


def find_or_create_user
  puts "Are you a new user [1] or returning [2]?"
  answer = get_user_input

  if answer == "1"
    puts "What would you like your username to be?"
    user_name = get_user_input
    the_user = User.find_or_create_by(user_name: user_name)

  elsif answer == "2"
    puts "What is your username?"
    user_name = get_user_input
    the_user = User.find_or_create_by(user_name: user_name)
end

the_user
end

def welcome(the_user)
  puts "Welcome to Jeopardy, #{the_user.user_name}. My name is Alex Trebek."
  options
end

def high_score(user)
  puts "Your high score is #{user.scores.map{|x| x.score}.max}"
  exit_game
end

def leader_board
  leader = []
    scores = Game.all.map{|x| x.score}.map{|x| x.score}
    players = Game.all.map{|x| x.user}.map{|x| x.user_name}
    players.zip(scores).each do |player, score|
      leader << {name: player, score: score}
    end
    leader.sort! {|a,b| a[:score] <=> b[:score]}.to_a
    puts leader.reverse!.take(5)
    leader.take(5)
    exit_game
end



def get_user_input
  gets.chomp
end


def pick_your_path(user)
  answer = get_user_input
  if answer == "1"
    player(user)
  elsif answer == "2"
    trivia
  elsif answer == "3"
    high_score(user)
  elsif answer == "4"
    leader_board
  elsif answer == "5"
    exit_game
  else
    invalid_command
    pick_your_path
  end
end


def filter
  loop do
    single_question = Question.find(rand(1..1207))
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

# def new_game
#   Game.new
# end

def create_game(the_user)
  Game.create(user: the_user)
end

def new_score(game, score)
  Score.create(game: game, score: score)
end

def ask_question
  winnings = 0
  thing = filter
  puts question = thing["question"]
  answer = thing["answer"]
  user_answer = get_user_input
  if "a #{user_answer.downcase}" == answer.downcase || user_answer.downcase == answer.downcase || "the #{user_answer.downcase}" == answer.downcase
    winnings += thing.value.value
    puts "\n Correct! \n"
  else
    puts "\n Wrong! The correct answer is #{answer}. \n"
  end
  winnings
end


def player(user)
  puts "This...is...Jeopardy!"
  tot_winnings = 0
  counter = 0
  while counter < 5
    winnings = ask_question
    tot_winnings += winnings
    counter += 1
  end
  tot_winnings
  the_game = create_game(user)
  new_score(the_game, tot_winnings)
  puts "Your winnings for this round add up to $#{tot_winnings}!"
  prompt_user
end



def prompt_user
  puts "Would you like to play another round? Please type yes [1] or no [2]"
    answer = get_user_input
  if answer == "1"
    player(user)
  elsif answer == "2"
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
  puts "[1] Number of questions asked in 1992"
  puts "[2] All of the categories from 1992"
  puts "[3] Interesting question from 1992"
  trivia_runner
end

def invalid_command
  "Please enter a valid command"
end

def exit_game
  puts "Thanks for visiting the Jeopardy app!"
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
  puts "Would you like to play a round of Jeopardy [1] or hear more trivia [2] or exit the game [3]?"
  response = get_user_input
  if response == '1'
    player
  elsif response == '2'
    trivia
  elsif  response == '3'
    exit_game
  end

end

def invalid_command
  puts "Please enter a valid command"
end

def options
  puts "Select a number for an option below:
  [1] play a round of Jeopardy
  [2] learn some Jeopardy trivia
  [3] see your high score
  [4] see the Jeopardy leader board
  [5] exit the game"
end

def runner
  new_user = find_or_create_user
  welcome(new_user)
  pick_your_path(new_user)
end
