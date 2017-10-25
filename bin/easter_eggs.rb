require 'net/http'
require 'uri'

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

  puts response.body
end
