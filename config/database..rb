require "sequel"

DB = Sequel.connect(
  ENV["DATABASE_URL"],
  sslmode: "require"   # REQUIRED for Supabase
)