require "dotenv/load"
require "sequel"

DB = Sequel.connect(ENV.fetch("DATABASE_URL"))
require_relative "../app/models/user"
require_relative "../app/models/resource"

admin_usernames = ENV.fetch("ADMIN_GITHUB_USERNAME").split(",").map(&:strip)

admin_usernames.each do |username|
  user = DB[:users].first(github_username: username)
  if user
    DB[:users].where(github_username: username).update(role: "admin")
    puts "Updated #{username} to admin"
  else
    DB[:users].insert(
      id:              Sequel.function(:gen_random_uuid),
      github_username: username,
      name:            username,
      email:           "#{username}@github.placeholder",
      role:            "admin",
      created_at:      Time.now
    )
    puts "Seeded admin: #{username}"
  end
end

resources_data = [
  {
    title: "Try Ruby", url: "https://try.ruby-lang.org", category: "Getting Started",
    description: "An interactive Ruby tutorial that runs entirely in your browser. Write real Ruby code and see instant results, no setup required."
  },
  {
    title: "Ruby in Twenty Minutes", url: "https://www.ruby-lang.org/en/documentation/quickstart/", category: "Getting Started",
    description: "The official Ruby quickstart guide. Covers the core language concepts in short, digestible steps with a focus on hands-on examples."
  },
  {
    title: "The Odin Project: Ruby", url: "https://www.theodinproject.com/paths/full-stack-ruby-on-rails/courses/ruby", category: "Getting Started",
    description: "A free, structured Ruby curriculum covering fundamentals through object-oriented design, with projects to build along the way."
  },
  {
    title: "The Well-Grounded Rubyist", url: "https://www.manning.com/books/the-well-grounded-rubyist-third-edition", category: "Books",
    description: "A thorough guide to Ruby's core language and standard library. Widely recommended for developers who want to understand Ruby deeply."
  },
  {
    title: "Programming Ruby 3.3 (Pickaxe)", url: "https://pragprog.com/titles/ruby5/programming-ruby-3-3-5th-edition/", category: "Books",
    description: "The definitive Ruby reference book, the Pickaxe. Covers the full language spec and standard library, updated for Ruby 3.3."
  },
  {
    title: "Eloquent Ruby", url: "https://www.oreilly.com/library/view/eloquent-ruby/9780321700308/", category: "Books",
    description: "Teaches you to write Ruby the way experienced Ruby developers write it, idiomatic, expressive, and making full use of the language."
  },
  {
    title: "Ruby API Docs", url: "https://rubyapi.org", category: "Documentation",
    description: "Clean, fast, and version-tagged Ruby standard library documentation. Easier to navigate than the official docs with great search."
  },
  {
    title: "Rails Guides", url: "https://guides.rubyonrails.org", category: "Documentation",
    description: "The official Rails documentation. Covers everything from getting started to advanced topics like Active Record, routing, and testing."
  },
  {
    title: "RubyGems", url: "https://rubygems.org", category: "Tools",
    description: "The public Ruby gem registry. Browse, search, and find libraries for nearly any task, the central hub for the Ruby ecosystem."
  },
  {
    title: "RuboCop", url: "https://rubocop.org", category: "Tools",
    description: "The standard Ruby static analysis and linting tool. Enforces community style guidelines and catches common code quality issues."
  },
  {
    title: "Ruby Weekly", url: "https://rubyweekly.com", category: "Community",
    description: "A weekly email newsletter with the best Ruby articles, news, and projects from across the community. Free to subscribe."
  },
  {
    title: "Why's (Poignant) Guide to Ruby", url: "https://poignant.guide/book", category: "Getting Started",
    description: "A quirky, comic-illustrated introduction to Ruby unlike any programming book you've read; funny, creative, and surprisingly effective."
  },
]

resources_data.each do |attrs|
  existing = DB[:resources].first(url: attrs[:url])
  if existing
    DB[:resources].where(url: attrs[:url]).update(description: attrs[:description])
    puts "Updated description: #{attrs[:title]}"
  else
    DB[:resources].insert(id: Sequel.function(:gen_random_uuid), is_approved: true, created_at: Time.now, **attrs)
    puts "Seeded resource: #{attrs[:title]}"
  end
end
