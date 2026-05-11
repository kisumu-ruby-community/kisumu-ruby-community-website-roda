require_relative "../services/resources_service"

module Routes
  class ResourcesRoute
    def self.call(r)
      ResourcesService.call
    end
  end
end
