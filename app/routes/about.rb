require_relative "../services/about_service"
module Routes
    class AboutRoute
        def self.call(r)
            AboutService.call(r)
        end
    end
end