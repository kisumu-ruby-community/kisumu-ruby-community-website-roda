class SecurityHeaders
  CSP = [
    "default-src 'self'",
    "script-src 'self' 'unsafe-inline'",
    "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com",
    "font-src 'self' https://fonts.gstatic.com",
    "img-src 'self' data: https://avatars.githubusercontent.com https://github.com",
    "connect-src 'self'",
    "frame-ancestors 'none'",
    "base-uri 'self'",
    "form-action 'self' https://formspree.io"
  ].join("; ").freeze

  HEADERS = {
    "X-Frame-Options"           => "DENY",
    "X-Content-Type-Options"    => "nosniff",
    "X-XSS-Protection"          => "1; mode=block",
    "Referrer-Policy"           => "strict-origin-when-cross-origin",
    "Permissions-Policy"        => "geolocation=(), microphone=(), camera=()",
    "Content-Security-Policy"   => CSP,
    "Strict-Transport-Security" => "max-age=31536000; includeSubDomains"
  }.freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    HEADERS.each { |k, v| headers[k] ||= v }
    [status, headers, body]
  end
end
