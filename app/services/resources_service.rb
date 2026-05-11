class ResourcesService
  def self.call
    resources  = Resource.where(is_approved: true).order(Sequel.desc(:created_at)).all
    categories = resources.map(&:category).compact.uniq.sort
    { title: "Resources", resources: resources, categories: categories }
  end
end
