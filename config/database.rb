require "sequel"

DB = Sequel.connect(
  ENV["DATABASE_URL"],
  sslmode: ENV["RACK_ENV"] == "production" ? "require" : "prefer"
)