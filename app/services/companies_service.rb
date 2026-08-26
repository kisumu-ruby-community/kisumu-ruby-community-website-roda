class CompaniesService
  def self.call
    companies = Company.where(is_approved: true).order(Sequel.desc(:created_at)).all
    countries = companies.map(&:country).compact.uniq.sort
    { title: "Built with Ruby", companies: companies, countries: countries }
  end
end
