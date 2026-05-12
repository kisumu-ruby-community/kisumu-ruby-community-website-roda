require "uri"

class Resource < Sequel::Model
  def display_host
    URI.parse(url).host&.sub(/\Awww\./, "") rescue url
  end
end
