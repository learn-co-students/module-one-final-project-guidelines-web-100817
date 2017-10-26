require 'pry'
require 'rest-client'
require 'net/http'
require 'json'
require 'uri'

require_relative '../config/environment.rb'

def get_headers
  client_id = 'ff0239ea44d165afc1ac'
  client_secret = '139d6ec5e1b5f82166205b21a92c1f1f'
  api_url = URI.parse('https://api.artsy.net/api/tokens/xapp_token')
  response = Net::HTTP.post_form(api_url, client_id: client_id, client_secret: client_secret)
  xapp_token = JSON.parse(response.body)['token']
  headers = {
    'X-Xapp-Token': xapp_token
  }
end

headers = get_headers

def get_response(url="https://api.artsy.net:443/api/artworks")
  client_id = 'ff0239ea44d165afc1ac'
  client_secret = '139d6ec5e1b5f82166205b21a92c1f1f'
  api_url = URI.parse('https://api.artsy.net/api/tokens/xapp_token')
  response = Net::HTTP.post_form(api_url, client_id: client_id, client_secret: client_secret)
  xapp_token = JSON.parse(response.body)['token']
  # curl -v -L https://api.artsy.net/api/artists/andy-warhol -H 'X-Xapp-Token:eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6IiIsImV4cCI6MTUwOTQ1OTQ2NywiaWF0IjoxNTA4ODU0NjY3LCJhdWQiOiI1OWVlMzQwMzljMThkYjdiNGY3ZWNkMjMiLCJpc3MiOiJHcmF2aXR5IiwianRpIjoiNTllZjRiOGIxMzliMjE2MzE4OGMwNTFjIn0.M0XBfUJLti38dxea1Xx8nVFjJg-JIaUWB2ZtEyvAziM'
  headers = {
    'X-Xapp-Token': xapp_token
  }
  response = JSON.parse(RestClient.get(url, headers))
end

response=get_response
# JSON.parse(RestClient.get(response["next"],headers))

def all_pieces(response)
  response["_embedded"].map { |artworks| artworks }
end

def all_imgs(response)
  response["_embedded"]["artworks"].each_with_object(imgs=[]) do |artwork|
    imgs<<artwork["_links"]["thumbnail"]["href"]
  end
  imgs
end

#write methods to get all the columns of the "piece" class
# t.string :name t.string :url t.string :img_url t.string :artist_name t.integer :gene_id t.integer :collection_id
def all_titles(response)
  response["_embedded"]["artworks"].each_with_object(titles=[]) do |artwork|
    titles<<artwork["title"]
  end
  titles
end

def all_permalinks(response)
  response["_embedded"]["artworks"].each_with_object(permalinks=[]) do |artwork|
    permalinks<<artwork["_links"]["permalink"]["href"]
  end
  permalinks
end

def all_artist_names(response, headers)
  response["_embedded"]["artworks"].each_with_object(artist_api_hrefs=[]) do |artwork|
    artist_api_hrefs<<artwork["_links"]["artists"]["href"]
  end
  artist_api_hrefs.each_with_object(artist_names=[]) do |artist_href|
    response = JSON.parse(RestClient.get(artist_href, headers))
    response["_embedded"]["artists"].each do |artist|
      artist_names<<artist["name"]
    end
  end
  artist_names
end

def all_gene_names(response, headers)
  response["_embedded"]["artworks"].each_with_object(gene_api_hrefs=[]) do |artwork|
    gene_api_hrefs<<artwork["_links"]["genes"]["href"]
  end
  gene_api_hrefs.each_with_object(genes=[]) do |gene_href|
    response = JSON.parse(RestClient.get(gene_href, headers))
    response["_embedded"]["genes"].each do |gene|
      genes<<gene["name"]
    end
  end
end

#write method to create instances w/ the above information
def create_pieces(response=response,headers=headers)
  imgs=all_imgs(response)
  titles=all_titles(response)
  permalinks=all_permalinks(response)
  artist_names=all_artist_names(response, headers)
  all_genes=all_gene_names(response, headers)
  i=0
  pieces = []
  genes = {}
  while i < titles.length do
    pieces << Piece.new(name: titles[i], url: permalinks[i], img_url: imgs[i], artist_name: artist_names[i])
    genes["#{pieces[i]}"] = all_genes[i..i+5]
    i+=1
  end
  hash = {pieces: pieces, genes: genes, next: response["_links"]["next"]["href"], self: response["_links"]["self"]["href"]}
end


def get_pieces(url="https://api.artsy.net:443/api/artworks")
  headers = get_headers
  response = get_response(url)
  create_pieces(response,headers)
end
