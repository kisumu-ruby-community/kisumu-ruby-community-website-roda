module Routes
  class JoinRoute
    def self.call(r)
      r.redirect "/contact"
    end
  end
end
