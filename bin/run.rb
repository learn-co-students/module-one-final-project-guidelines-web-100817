require_relative '../config/environment'
require_relative './run_methods.rb'

greet
keep_database?
answer = nil
while answer != "q"
  case answer = get_user_input
  when "h"
    help
  when "q"
    break
  when "number of friends"
    number_of_friends
  when "number of tweets"
    number_of_tweets
  when "number of hashtags"
    number_of_hashtags
  when "most popular friend"
    most_popular_friend
  when "most popular tweet"
    most_popular_tweet
  when "most popular hashtag"
    most_popular_hashtag
  when "friend table"
    friend_table
  when "most positive friend"
    most_positive_friend
  when "most negative friend"
    most_negative_friend
  when "most positive tweet"
    most_positive_tweet
  when "most negative tweet"
    most_negative_tweet
  else
    err
  end
end
goodbye
