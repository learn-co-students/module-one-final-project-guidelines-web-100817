class Track < ActiveRecord::Base
  has_many :artist_tracks
  has_many :artists, through: :artist_tracks

 def self.find_longest_song
    number = Track.maximum('duration')
    number = number * 1.66667e-5
   longest_song = self.all.sort_by {|track| track.duration}.reverse.first.name
   puts "\n#{longest_song} at #{number.round(2)} minutes\n"
 end

 def self.find_most_popular_song
   most_popular_track = self.all.sort_by {|track| track.popularity}.first.name
   puts "\n#{most_popular_track}\n"
 end

 def self.find_least_popular_song
   least_popular_track = self.all.sort_by {|track| track.popularity}.reverse.first.name
   puts "\n#{least_popular_track}\n"
 end

 def self.find_artists_for_song(song)
   artists_for_song = self.all.find_by_name(song).artists.uniq.map do |artist|
     artist.name
   end
   puts "\n#{artists_for_song}\n"
 end



end
