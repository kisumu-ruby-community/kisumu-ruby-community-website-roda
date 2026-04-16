require "rack/attack"

Rack::Attack.cache.store = Class.new do
  def initialize
    @data  = {}
    @mutex = Mutex.new
  end

  def increment(key, amount, options = {})
    @mutex.synchronize do
      expires_in = options[:expires_in] || 60
      entry = @data[key]
      if entry.nil? || entry[:expires_at] < Time.now
        @data[key] = { value: amount, expires_at: Time.now + expires_in }
      else
        @data[key][:value] += amount
      end
      @data[key][:value]
    end
  end

  def read(key)
    @mutex.synchronize do
      entry = @data[key]
      return nil if entry.nil? || entry[:expires_at] < Time.now
      entry[:value]
    end
  end

  def write(key, value, options = {})
    @mutex.synchronize do
      expires_in = options[:expires_in] || 60
      @data[key] = { value: value, expires_at: Time.now + expires_in }
    end
  end
end.new

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
