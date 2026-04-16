require "dotenv/load"
require "roda"
require "omniauth"
require "omniauth-github"
require "cgi"
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

  use OmniAuth::Builder do
    provider :github,
      ENV.fetch("GITHUB_CLIENT_ID"),
      ENV.fetch("GITHUB_CLIENT_SECRET"),
      scope: "user:email"
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
    request.redirect "/" unless current_user&.admin?
  end

  route do |r|
    r.public

    # GitHub OAuth
    r.on "auth" do
      r.on "github" do
        r.on "callback" do
          auth = request.env["omniauth.auth"]
          user = User.from_github(auth)
          
          admin_usernames = ENV.fetch("ADMIN_GITHUB_USERNAME", "").split(",").map(&:strip)
          if admin_usernames.include?(user.github_username) && !user.admin?
            user.promote_to_admin
          end
          session[:user_id] = user.id
          display_name = CGI.escapeHTML((user.name || user.github_username).to_s.strip)
          session[:flash]   = "Welcome, #{display_name}!"
          r.redirect session.delete(:return_to) || "/"
        end
      end
    end

    r.post "logout" do
      session.clear
      r.redirect "/"
    end

    # Public pages
    r.get "health" do
      response.status = 200
      "OK #{Time.now.utc.iso8601}"
    end

    r.root { view("pages/index", locals: Routes::HomeRoute.call(r)) }

    r.on("about")     { view("pages/about",     locals: Routes::AboutRoute.call(r)) }
    # r.on("members")   { view("pages/members",   locals: Routes::MembersRoute.call(r)) }
    # r.on("resources") { view("pages/resources", locals: Routes::ResourcesRoute.call(r)) }

    r.on "contact" do
      r.get  { view("pages/contact", locals: { title: "Contact & Join" }) }
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
        view("pages/events/show", locals: Routes::EventsRoute.show(r, id, current_user))
      end
      r.is { view("pages/events/index", locals: Routes::EventsRoute.call(r)) }
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
