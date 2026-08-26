require "uri"

class Company < Sequel::Model
  def display_host
    URI.parse(website_url).host&.sub(/\Awww\./, "") rescue website_url
  end
end
