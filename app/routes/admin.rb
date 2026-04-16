require_relative "../services/admin/events_admin_service"

module Routes
  class AdminRoute
    def self.call(r, app)
      r.is { r.redirect "/admin/events" }

      r.on "events" do
        r.is do
          r.get  { app.view("pages/admin/events/index", locals: { events: EventsAdminService.all }) }
          r.post do
            EventsAdminService.create(r.params, app.current_user)
            r.redirect "/admin/events"
          end
        end

        r.on "new" do
          r.get { app.view("pages/admin/events/form", locals: { event: nil, errors: {} }) }
        end

        r.on String do |id|
          halt 400 unless id.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
          event = EventsAdminService.find(id)

          r.on "edit" do
            r.get { app.view("pages/admin/events/form", locals: { event: event, errors: {} }) }
          end

          r.post "delete" do
            EventsAdminService.delete(id)
            r.redirect "/admin/events"
          end

          r.post do
            errors = EventsAdminService.update(id, r.params)
            if errors.empty?
              r.redirect "/admin/events"
            else
              app.view("pages/admin/events/form", locals: { event: event, errors: errors })
            end
          end
        end
      end
    end
  end
end
