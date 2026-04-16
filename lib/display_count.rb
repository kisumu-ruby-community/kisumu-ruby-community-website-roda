module DisplayCount
  THRESHOLDS = [[1000, ->(x) { "#{x / 1000}K+" }],
                [500,  ->(_) { "500+" }],
                [100,  ->(x) { "#{(x / 100) * 100}+" }],
                [50,   ->(_) { "50+" }],
                [10,   ->(x) { "#{(x / 10) * 10}+" }],
                [1,    ->(_) { "1+" }]].freeze

  def self.call(n)
    return "0" if n == 0
    _, fmt = THRESHOLDS.find { |min, _| n >= min }
    fmt.call(n)
  end
end
