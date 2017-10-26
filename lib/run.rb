require_relative '../config/environment.rb'


def welcome
  # Control Methods

puts "\n\e[1m       WELCOME TO OUR MUSIC DATABASE!\e[0m\n"
puts "\n********************************************\n"
puts "\e[34m
        _                       ____
       ( )                     |____|
    ___|/________|\____________|____|_______
   |__/|/_)_|____|_______|\__(_)__(_)_______|
   |_(_|_/__|__(_)_______|\_________________|
   |___|____|__________(_)__________________|
   |________|_________________________(_)___|
                                        |
                                        |\e[0m\n"

puts "\n********************************************\n"

  puts "\nYou have access to the Spotify information for the Billboard 'Hot' 100 artists and tracks!\n"



end

def goodbye
  # Exit method
  puts "\nHave a nice day!"
  puts "\n\e[31m^(^o^)^" + "\e[32m <('o'<)" + "\e[33m <('-')>"+ "\e[34m (>'o')>" +"\e[35m ^(^o^)^\n\n"
end

def start_over
  # Returns to inital_selections and initial_user_selection
  puts "\nWould you like to search something else?\n"
  puts "1. Artist Database"
  puts "2. Track Database"
  puts "3. Exit\n"
  input = gets.chomp
  case input
  when '1'
    artist_menu
    artist_selection
  when '2'
    track_menu
    track_selection
  when '3'
    goodbye
  else
    puts "\nThis is not a correct input! Please try again!"
    start_over
  end
end
###########################################################
# Initial Menu Methods
def initial_menu
  #Initial available selections for CLI
  puts "\nPlease select one of the following options:\n"
  puts "1. Search Artist Database"
  puts "2. Search Song Database\n\n"

end

def initial_user_selection
  #Initial user selection for CLI
  input = gets.chomp


  case input
  when "1"
    artist_menu
    artist_selection
  when "2"
    track_menu
    track_selection
  else
    puts 'This is not a correct input! Please try again!'
    initial_user_selection
  end
end
######################################################
# Artist Menu
def artist_menu
  #if popularity is selected provide possible choices

  puts "\nPlease select one of the following options:"
  puts '1. Search By Artist Name'
  puts '2. Most Popular Artist'
  puts '3. Least Popular Artist'
  puts "4. List Songs By Most Popular Artist"
  puts "5. Find Artist With the Most Hits\n"
end

# # Artist Selections
# def artist_selection_1_restart
#   artist_selection_1
# end

def artist_selection_1
  puts "\nPlease enter an artist name:"
  artist = Artist.find_artist(gets.chomp)
  unless artist
    puts "Sorry that artist is not on the Billboard Top-100!"
    artist_selection_1
  end
  songs = artist.tracks.uniq.map { |track| track.name }

  puts "\n#{artist.name}'s popularity: #{artist.popularity}"
  puts "#{artist.name}'s songs on the Top 100: #{songs.join(', ')}\n"
end

def artist_selection
  # run appropriate class method for selected option
  input = gets.chomp
  case input
  when "1"
    artist_selection_1
  when "2"
    Artist.most_popular_artist
  when "3"
    Artist.least_popular_artist
  when "4"
    artist = Artist.most_popular_artist_without_puts
    puts "The most popular songs by #{artist} are:\n"
    Artist.find_songs_by_most_popular_artist
  when "5"
    Artist.find_artist_with_most_hits
  end
  start_over
end

#####################################################
# Track menu
def track_menu
  #if popularity is selected provide possible choices
  puts "\nPlease select one of the following options:"
  puts "1. Search By Track Name"
  puts "2. Most Popular Track"
  puts "3. Least Popular Track"
  puts "4. Find Longest Song"
end

def track_selection_1
  puts "Please enter a track name:"
  track = Track.find_by_name(gets.chomp)
  unless track
    puts "Sorry that track is not on the Billboard Top-100!"
    track_selection_1
  end
  #binding.pry
  puts "This song is by #{track.artists.uniq[0].name}"
  puts "#{track.name} has a popularity of: #{track.popularity}"
end


# Track selections
def track_selection
  # run appropriate class method for selected option
  input = gets.chomp
  case input
  when "1"
    track_selection_1
  when "2"
    Track.find_most_popular_song
  when "3"
    Track.find_least_popular_song
  when "4"
    Track.find_longest_song
  end
  start_over
end

welcome
initial_menu
initial_user_selection
