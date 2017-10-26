

require 'pry'
require 'rspotify'
require 'nokogiri'
require 'open-uri'

#Get the Billboard top 200 artists and songs list
html = Nokogiri::HTML(open('http://www.billboard.com/charts/hot-100'))
#create empty arrays for both artists and songs for seeding later
artists = []
tracks = []

# iterate over all artists in HTML, format them and insert into associated array
html.css('span.chart-row__artist').each do |item|
  artists << item.text.delete!("\n")
end

#iterate over all tracks in HTML, format them and insert into associated array
html.css('h2.chart-row__song').each do |item|
    tracks << item.text
end


RSpotify::authenticate("ecc749dc5d5647aab606d9284fccd522", "476c52de3ac2437d90104d8995222e22")

# artist_object = artists[0..49].map {|artist| RSpotify::Artist.search(artist)}
track_object = tracks[0..49].map {|track| RSpotify::Track.search(track)}
sleep 15
# artist_object.concat(artists[50..-1].map {|artist| RSpotify::Artist.search(artist)})
track_object.concat(tracks[50..-1].map {|track| RSpotify::Track.search(track)})


track_object.each do |track|
  # track.each do |item|
    # creates a row with variable name song
    item = track.first
  song = Track.find_or_create_by(name: item.name, popularity: item.popularity, duration: item.duration_ms, track_uniq_id: item.id)
  item.artists.each do |art|
      #finds the artist by its spotify id
    a = Artist.find_by(artist_uniq_id: art.id)
      if !a
        artist = RSpotify::Artist.find(art.id)
          new_artist = Artist.create(name: artist.name, popularity: artist.popularity, artist_uniq_id: artist.id)
          new_artist.tracks << song
      else
        a.tracks << song
      end
    end
end



# Track.all.each do |track|
#   song = RSpotify::Track.find(track.track_uniq_id)
#    song[0].artists.each do |array_item|
#   Artist.all.each do |artist|
#     if artist.artist_uniq_id == array_item.id
#       ArtistTrack.create(artist_id: artist.id, track_id: track.id)
#     end
# end
# end
