require_relative "../../lib/display_count"

class HomeService
  def self.call(r)
    {
      title:         "Kisumu Ruby Community",
      members_count: DisplayCount.call(DB[:users].count),
      events_count:  DisplayCount.call(DB[:events].where(status: "published").count),
    }
  end
end
