class ResourcesAdminService
  def self.all
    Resource.order(Sequel.desc(:created_at)).all
  end

  def self.find(id)
    Resource.first(id: id)
  end

  def self.create(params)
    Resource.create(permitted(params).merge(is_approved: true, created_at: Time.now))
  end

  def self.update(id, params)
    errors = validate(params)
    return errors unless errors.empty?
    Resource.first(id: id).update(permitted(params))
    errors
  end

  def self.delete(id)
    Resource.first(id: id)&.delete
  end

  private

  def self.validate(params)
    errors = {}
    errors[:title] = "Title is required" if params["title"].to_s.strip.empty?
    errors[:url]   = "URL is required"   if params["url"].to_s.strip.empty?
    errors
  end

  def self.permitted(params)
    cat  = params["category"].to_s.strip
    desc = params["description"].to_s.strip
    {
      title:       params["title"].to_s.strip,
      url:         params["url"].to_s.strip,
      category:    cat.empty?  ? nil : cat,
      description: desc.empty? ? nil : desc
    }
  end
end
