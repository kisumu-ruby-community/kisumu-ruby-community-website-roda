require "rack/attack"

# 5 auth attempts per IP per minute
Rack::Attack.throttle("auth/ip", limit: 5, period: 60) do |req|
  req.ip if req.path.start_with?("/auth/")
end

# 10 form POSTs per IP per minute (contact, rsvp)
Rack::Attack.throttle("post/ip", limit: 10, period: 60) do |req|
  req.ip if req.post?
end

# 300 requests per IP per 5 minutes (general)
Rack::Attack.throttle("req/ip", limit: 300, period: 300) do |req|
  req.ip unless req.path.start_with?("/assets", "/style.css")
end

Rack::Attack.throttled_responder = lambda do |_req|
  [429, { "Content-Type" => "text/plain" }, ["Too many requests. Please try again later."]]
end
