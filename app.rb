require "dotenv/load"
require "roda"
require "omniauth"
require "omniauth-github"
require_relative "config/database"
require_relative "app/models/user"
require_relative "app/models/event"
require_relative "app/models/event_speaker"
require_relative "app/routes/home"
require_relative "app/routes/about"
require_relative "app/routes/contact"
require_relative "app/routes/events"
# require_relative "app/routes/blog"
# require_relative "app/routes/members"
# require_relative "app/routes/resources"
require_relative "app/routes/admin"

OmniAuth.config.allowed_request_methods = %i[get post]
OmniAuth.config.silence_get_warning     = true

class App < Roda
  plugin :render, views: "app/views"
  plugin :public
  plugin :all_verbs
  plugin :halt
  plugin :error_handler
  plugin :not_found

  not_found { view("pages/404") }

  error do |e|
    Sentry.capture_exception(e) if defined?(Sentry)
    response.status = 500
    view("pages/500")
  end

  use OmniAuth::Builder do
    provider :github,
      ENV.fetch("GITHUB_CLIENT_ID"),
      ENV.fetch("GITHUB_CLIENT_SECRET"),
      scope: "user:email"
  end

  # SEO helper
  def seo(opts = {})
    @seo = opts
  end

  # Auth helpers
  def current_user
    @current_user ||= session[:user_id] && User.first(id: session[:user_id])
  end

  def require_login!
    unless current_user
      session[:return_to] = request.path
      request.redirect "/auth/github"
    end
  end

  def require_admin!
    require_login!
    halt 404 unless current_user&.admin?
  end

  route do |r|
    r.public

    # GitHub OAuth
    r.on "auth" do
      r.on "github" do
        r.on "callback" do
          auth = request.env["omniauth.auth"]
          user = User.from_github(auth)
          session[:user_id] = user.id
          session[:flash]   = user.welcome_message
          r.redirect session.delete(:return_to) || "/"
        end
      end
    end

    r.post "logout" do
      session.clear
      r.redirect "/"
    end

    # Sitemap
    r.get "sitemap.xml" do
      response["Content-Type"] = "application/xml; charset=utf-8"
      event_ids = DB[:events].select(:id).map(:id)
      base = request.base_url
      static = ["/", "/about", "/events", "/contact"]
      urls = static.map { |p| "#{base}#{p}" } +
             event_ids.map { |id| "#{base}/events/#{id}" }
      <<~XML
        <?xml version="1.0" encoding="UTF-8"?>
        <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
          #{urls.map { |u| "<url><loc>#{u}</loc></url>" }.join("\n  ")}
        </urlset>
      XML
    end

    # Public pages
    r.get "health" do
      response.status = 200
      "OK #{Time.now.utc.iso8601}"
    end

    r.root do
      seo(
        description: "Kisumu's community of Ruby and Rails developers. Learn together, build real things, and grow the tech ecosystem of Western Kenya.",
        url: "#{request.base_url}/"
      )
      view("pages/index", locals: Routes::HomeRoute.call(r))
    end

    r.on("about") do
      seo(
        title: "About",
        description: "Learn about the Kisumu Ruby Community — our origin story, mission, values, and the people behind it.",
        url: "#{request.base_url}/about"
      )
      view("pages/about", locals: Routes::AboutRoute.call(r))
    end
    # r.on("members")   { view("pages/members",   locals: Routes::MembersRoute.call(r)) }
    # r.on("resources") { view("pages/resources", locals: Routes::ResourcesRoute.call(r)) }

    r.on "contact" do
      r.get do
        seo(
          title: "Contact & Join",
          description: "Get in touch with the Kisumu Ruby Community, propose a talk, or join as a member.",
          url: "#{request.base_url}/contact"
        )
        view("pages/contact", locals: { title: "Contact & Join" })
      end
      r.post { Routes::ContactRoute.call(r) }
    end

    r.on "events" do
      r.on String do |id|
        halt 400 unless id.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
        r.post "rsvp" do
          require_login!
          Routes::EventsRoute.rsvp(r, id, current_user)
          r.redirect "/events/#{id}"
        end
        r.on "rsvp" do
          r.post "cancel" do
            require_login!
            Routes::EventsRoute.cancel_rsvp(r, id, current_user)
            r.redirect "/events/#{id}"
          end
        end
        locals = Routes::EventsRoute.show(r, id, current_user)
        if (ev = locals[:event])
          seo(
            title: ev.title,
            description: ev.description.to_s.slice(0, 160),
            url: "#{request.base_url}/events/#{id}",
            type: "event",
            **(ev.poster? ? { image: ev.cover_image } : {})
          )
        end
        view("pages/events/show", locals: locals)
      end
      r.is do
        seo(
          title: "Events",
          description: "Upcoming and past Ruby and Rails events from the Kisumu Ruby Community.",
          url: "#{request.base_url}/events"
        )
        view("pages/events/index", locals: Routes::EventsRoute.call(r))
      end
    end

    # r.on "blog" do
    #   r.on String do |slug|
    #     view("pages/blog/show", locals: Routes::BlogRoute.show(r, slug))
    #   end
    #   r.is { view("pages/blog/index", locals: Routes::BlogRoute.call(r)) }
    # end

    # Admin
    r.on "admin" do
      require_admin!
      Routes::AdminRoute.call(r, self)
    end
  end
end
