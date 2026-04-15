require "rack/session"
require "./app"

use Rack::Session::Cookie,
  key:       "_krc_session",
  secret:    ENV.fetch("SESSION_SECRET"),
  same_site: :lax,
  http_only: true

run App
