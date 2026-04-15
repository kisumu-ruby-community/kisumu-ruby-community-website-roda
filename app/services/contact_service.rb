require "net/http"
require "json"
require "uri"

class ContactService
  CONTACT_URL  = ENV.fetch("FORMSPREE_CONTACT_URL")
  PROPOSAL_URL = ENV.fetch("FORMSPREE_PROPOSAL_URL")

  def self.call(r)
    form = r.params
    url  = form["_form"] == "proposal" ? PROPOSAL_URL : CONTACT_URL
    payload = form.reject { |k, _| k.start_with?("_") }

    uri  = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, "Content-Type" => "application/json", "Accept" => "application/json")
    req.body = payload.to_json
    http.request(req)

    r.redirect "/contact?sent=#{form["_form"] == "proposal" ? "proposal" : "contact"}"
  end
end
