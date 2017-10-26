class ArtistTrack < ActiveRecord::Base
  belongs_to :artist
  belongs_to :track


  #<ArtistTrack:0x007fcc5613c8e0 id: 13, artist_id: 13, track_id: 9>,
   #<ArtistTrack:0x007fcc5613c728 id: 14, artist_id: 14, track_id: 9>,

end
