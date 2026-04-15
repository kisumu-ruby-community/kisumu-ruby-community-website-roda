require_relative "../services/home_service"
module Routes
    class HomeRoute
        def self.call(r)
            HomeService.call(r)
        end
    end
end