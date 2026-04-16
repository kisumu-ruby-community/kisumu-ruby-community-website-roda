require "rack/session"
require "rack/attack"
require "sentry-ruby"
require "json"
require_relative "lib/middleware/security_headers"
require_relative "config/rack_attack"
require_relative "app"

# Sentry error tracking
Sentry.init do |config|
  config.dsn              = ENV["SENTRY_DSN"]
  config.environment      = ENV.fetch("RACK_ENV", "development")
  config.enabled_environments = %w[production staging]
  config.traces_sample_rate = 0.2
end

# Structured request logger
class RequestLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    start  = Time.now
    status, headers, body = @app.call(env)
    duration = ((Time.now - start) * 1000).round(2)
    req = Rack::Request.new(env)
    $stdout.puts JSON.generate(
      time:        Time.now.utc.iso8601,
      method:      req.request_method,
      path:        req.path,
      status:      status,
      duration_ms: duration,
      ip:          req.ip
    )
    $stdout.flush
    [status, headers, body]
  end
end

use SecurityHeaders
use Rack::Attack
use RequestLogger

use Rack::Session::Cookie,
  key:       "_krc_session",
  secret:    ENV.fetch("SESSION_SECRET"),
  same_site: :lax,
  http_only: true,
  secure:    ENV.fetch("RACK_ENV", "development") == "production"

run App
