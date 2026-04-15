require_relative "../services/join_service"

module Routes
  class JoinRoute
    def self.call(r)
      JoinService.call(r)
    end
  end
end
