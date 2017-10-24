require_relative '../config/environment'
require_relative './run_methods.rb'

greet
keep_database?
answer = nil
while answer != "q"
  case answer = get_user_input
  when "help"
    help
  when "quit"
    break
  ### BASICS ###
  when "number of friends"
    number_of_friends
  when "number of tweets"
    number_of_tweets
  when "number of hashtags"
    number_of_hashtags
  when "get details for user"
    get_details_for_user
  when "most popular friend"
    most_popular_friend
  when "most popular tweet"
    most_popular_tweet
  when "most popular hashtag"
    most_popular_hashtag
  when "friend table"
    friend_table
  when "hashtag table"
    hashtag_table
  when "most positive friend"
    most_positive_friend
  when "most negative friend"
    most_negative_friend
  when "most positive tweet"
    most_positive_tweet
  when "most negative tweet"
    most_negative_tweet
  when "average friend sentiment"
    average_friend_sentiment
  when "most positive hashtag"
    most_positive_hashtag
  when "most negative hashtag"
    most_negative_hashtag
  when "top 10 most popular friends"
    top_ten_popular_friends
  when "top 10 most popular tweets"
    top_ten_popular_tweets
  when "top 10 most popular hashtags"
    top_ten_popular_hashtags
  when "my sentiment"
    my_sentiment
  when "my most positive tweet"
    my_most_positive_tweet
  when "my most negative tweet"
    my_most_negative_tweet
  when "my most popular tweet"
    my_most_popular_tweet
  else
    err
  end
end
goodbye
