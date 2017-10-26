require 'pry'
class Artist < ActiveRecord::Base
  has_many :artist_tracks
  has_many :tracks, through: :artist_tracks

#most popular artist
  def self.most_popular_artist
    popular_artist = self.all.sort_by {|artist| artist.popularity}.reverse.first.name
    puts "\n#{popular_artist}\n"
  end

  def self.most_popular_artist_without_puts
    popular_artist = self.all.sort_by {|artist| artist.popularity}.reverse.first.name
  end

  def self.least_popular_artist
    unpopular_artist = self.all.sort_by {|artist| artist.popularity}.first.name
    puts "\n#{unpopular_artist}\n"
  end

# find most popular artists songs
  def self.find_songs_by_most_popular_artist
    popular_songs = self.all.sort_by {|artist| artist.popularity}.reverse.first.tracks.map do |track|
      track.name
    end
    puts popular_songs.uniq
  end

  def self.find_artist(name)
    found_artist = self.all.find_by_name(name)
    found_artist
  end
  #
  def self.find_artist_with_most_hits
    artisttrack = ArtistTrack.all.map {|artisttrack| artisttrack.artist_id}.group_by {|artist_id| artist_id}.flatten.flatten
    artisttrack = artisttrack.sort_by {|number| artisttrack.count(number)}.reverse
    hash = {}
    artisttrack.each do |artist_id|
      if hash[artist_id]
        hash[artist_id] += 1
      else
        hash[artist_id] = 1
      end
    end

    array = []
    hash.each do |key, value|
      max = hash.values.max
        if hash[key] == max
          array << key
        end
    end

    artists_with_most_hits = array.collect do |number|
      Artist.find(number).name
    end

    artists_with_most_hits_last = "and " + artists_with_most_hits[-1]
    artists_with_most_hits_first = artists_with_most_hits[0...-1].join(", ")

    puts "\nThe artists with the most hits are: #{artists_with_most_hits_first} #{artists_with_most_hits_last}"

  end

end
