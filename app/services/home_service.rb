class HomeService
  MILESTONES = [1000, 500, 100, 50, 10, 1].freeze

  def self.display_count(n)
    return "0" if n == 0
    thresholds = [[1000, ->(x) { "#{x / 1000}K+" }],
                  [500,  ->(_) { "500+" }],
                  [100,  ->(x) { "#{(x / 100) * 100}+" }],
                  [50,   ->(_) { "50+" }],
                  [10,   ->(x) { "#{(x / 10) * 10}+" }],
                  [1,    ->(_) { "1+" }]]
    _, fmt = thresholds.find { |min, _| n >= min }
    fmt.call(n)
  end

  def self.call(r)
    {
      title:         "Kisumu Ruby Community",
      members_count: display_count(DB[:users].count),
      events_count:  display_count(DB[:events].where(status: "published").count),
    }
  end
end
