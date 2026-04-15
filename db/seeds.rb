require "sequel"
require "bcrypt"

DB = Sequel.connect(ENV["DATABASE_URL"] || "postgres://abu:postgres@localhost/kisumu_ruby_community")

DB[:users].insert_conflict(target: :email).insert(
  name: "Alice Otieno",
  email: "alice@example.com",
  password_digest: BCrypt::Password.create("password123"),
  created_at: Time.now
)

DB[:users].insert_conflict(target: :email).insert(
  name: "Brian Odhiambo",
  email: "brian@example.com",
  password_digest: BCrypt::Password.create("password123"),
  created_at: Time.now
)

puts "Seeded #{DB[:users].count} users"
