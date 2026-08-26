class CompaniesAdminService
  def self.all
    Company.order(Sequel.desc(:created_at)).all
  end

  def self.find(id)
    Company.first(id: id)
  end

  def self.create(params)
    errors = validate(params)
    return errors unless errors.empty?
    Company.create(permitted(params).merge(created_at: Time.now))
    errors
  end

  def self.update(id, params)
    errors = validate(params)
    return errors unless errors.empty?
    Company.first(id: id).update(permitted(params))
    errors
  end

  def self.delete(id)
    Company.first(id: id)&.delete
  end

  private

  def self.validate(params)
    errors = {}
    errors[:name]        = "Name is required"        if params["name"].to_s.strip.empty?
    errors[:website_url] = "Website URL is required"  if params["website_url"].to_s.strip.empty?
    errors
  end

  def self.permitted(params)
    logo    = params["logo_url"].to_s.strip
    desc    = params["description"].to_s.strip
    country = params["country"].to_s.strip
    cat     = params["category"].to_s.strip
    {
      name:        params["name"].to_s.strip,
      website_url: params["website_url"].to_s.strip,
      logo_url:    logo.empty?    ? nil : logo,
      description: desc.empty?    ? nil : desc,
      country:     country.empty? ? nil : country,
      category:    cat.empty?     ? nil : cat,
      is_approved: params["is_approved"] == "1"
    }
  end
end
