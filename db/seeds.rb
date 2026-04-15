require "dotenv/load"
require "sequel"

DB = Sequel.connect(ENV.fetch("DATABASE_URL"))
require_relative "../app/models/user"

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
