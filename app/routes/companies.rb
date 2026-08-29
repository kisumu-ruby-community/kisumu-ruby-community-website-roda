require_relative "../services/companies_service"

module Routes
  class CompaniesRoute
    def self.call(r)
      CompaniesService.call
    end
  end
end
