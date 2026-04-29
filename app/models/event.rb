require "cgi"

class Event < Sequel::Model
  one_to_many :speakers, class: :EventSpeaker, key: :event_id
  one_to_many :rsvps

  def virtual?   = !meeting_url.nil? && !meeting_url.empty?
  def upcoming?  = date && date > Time.now
  def poster?    = !cover_image.nil? && !cover_image.empty?

  # Generates a Google Calendar "Add to Calendar" URL.
  # Times are stored as EAT local time (no tz conversion at entry), so we
  # pass them without a UTC Z suffix and let ctz=Africa/Nairobi anchor them.
  def google_calendar_url
    fmt     = ->(t) { t.strftime("%Y%m%dT%H%M%S") }
    start_t = date || Time.now
    end_t   = end_date || (start_t + 3600)
    params  = {
      action:   "TEMPLATE",
      text:     title,
      dates:    "#{fmt.(start_t)}/#{fmt.(end_t)}",
      details:  description.to_s.slice(0, 500),
      location: virtual? ? meeting_url : location.to_s,
      ctz:      "Africa/Nairobi",
    }
    ENV.fetch("GOOGLE_CALENDAR_BASE_URL") +
      params.map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join("&")
  end
end
