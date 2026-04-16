require "cgi"

class User < Sequel::Model
  def admin?  = role == "admin"
  def member? = role == "member" || admin?

  def welcome_message
    safe_name = CGI.escapeHTML((name || github_username).to_s.strip)
    "Welcome, #{safe_name}!"
  end
  def self.from_github(auth)
    user = first(github_id: auth["uid"].to_s) ||
           first(github_username: auth.dig("info", "nickname"))

    attrs = {
      github_id:       auth["uid"].to_s,
      github_username: auth.dig("info", "nickname"),
      name:            auth.dig("info", "name") || auth.dig("info", "nickname"),
      email:           auth.dig("info", "email") || "",
      avatar_url:      auth.dig("info", "image"),
    }

    if user
      user.update(attrs)
    else
      attrs[:role] = "visitor"
      user = create(attrs)
    end

    admin_usernames = ENV.fetch("ADMIN_GITHUB_USERNAME", "").split(",").map(&:strip)
    user.promote_to_admin if admin_usernames.include?(user.github_username) && !user.admin?
    user
  end
end
