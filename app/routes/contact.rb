require_relative "../services/contact_service"

module Routes
    class ContactRoute
        def self.call(r)
            ContactService.call(r)
        end
    end
end