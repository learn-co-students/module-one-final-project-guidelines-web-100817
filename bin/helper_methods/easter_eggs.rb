require 'net/http'
require 'uri'
require 'json'
require 'httparty'

def random_joke
  uri = URI.parse("https://icanhazdadjoke.com/")
  request = Net::HTTP::Get.new(uri)
  request["Accept"] = "text/plain"

  req_options = {
    use_ssl: uri.scheme == "https",
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  puts "You asked for it!"
  puts response.body
end

def random_cat_fact
    uri = URI.parse("https://catfact.ninja/fact")
  request = Net::HTTP::Get.new(uri)
  request["Accept"] = "application/json"

  req_options = {
    use_ssl: uri.scheme == "https",
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  doc = JSON.parse(response.body)
  puts "Did you know..."
  puts "\u{1F431} #{doc["fact"]}"
end
