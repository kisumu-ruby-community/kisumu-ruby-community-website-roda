require "roda"
require_relative "app/routes/home"
require_relative "app/routes/about"
require_relative "app/routes/contact"
require_relative "app/routes/join"

class App < Roda
    plugin :render, views: "app/views"
    plugin :public
    plugin :json
    plugin :all_verbs

    route do |r|
        r.public
        r.root do
            view("pages/index", locals: Routes::HomeRoute.call(r))
        end
        r.on "about" do
            view("pages/about", locals: Routes::AboutRoute.call(r))
        end
        r.on "contact" do
            view("pages/contact", locals: Routes::ContactRoute.call(r))
        end
        r.on "join" do
            view("pages/join", locals: Routes::JoinRoute.call(r))
        end
    end
end