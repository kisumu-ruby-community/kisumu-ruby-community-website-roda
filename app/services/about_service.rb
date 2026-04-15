class AboutService
  VALUES = [
    { title: "Learn Together",     description: "We grow by sharing knowledge, from beginner questions to advanced architecture discussions, every voice matters." },
    { title: "Build Real Things",  description: "We ship code. Hackathons, open-source contributions, and community projects keep us grounded in practice." },
    { title: "Grow the Ecosystem", description: "We invest in Western Kenya's tech future by mentoring new developers and connecting talent with opportunity." },
    { title: "Stay Inclusive",     description: "Ruby's community has always been welcoming. We carry that spirit, everyone belongs here regardless of experience level." },
  ].freeze

  ORGANIZERS = [
    { name: "Abraham King'oo", role: "Organizer",      initials: "AK", bio: "Software Engineer. Passionate about Ruby and building developer communities in East Africa.",  github: "abrakingoo" },
    { name: "Paul Oguda",      role: "Community Lead", initials: "PO", bio: "Senior Ruby Engineer. Passionate about Ruby, Rails, and mentoring developers.",               github: "kamalogudah" },
    { name: "John Odhiambo",   role: "Organizer",      initials: "JO", bio: "Software Engineer. Passionate about communities.",                                              github: "johneliud" },
  ].freeze

  def self.call(r)
    { title: "About", core_values: VALUES, organizers: ORGANIZERS }
  end
end
