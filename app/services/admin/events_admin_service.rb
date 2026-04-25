require_relative "../../../lib/utils/image_upload"

class EventsAdminService
  REQUIRED = %w[title date].freeze

  def self.all
    Event.order(Sequel.desc(:date)).all
  end

  def self.find(id)
    Event.first(id: id)
  end

  def self.create(params, user)
    attrs = permitted(params).merge(
      cover_image: resolve_image(params["cover_image_file"], params["cover_image"]),
      created_by:  user.id,
      created_at:  Time.now
    )
    event = Event.create(attrs)
    sync_speakers(event, params["speakers"] || [])
    event
  end

  def self.update(id, params)
    errors = validate(params)
    return errors unless errors.empty?
    event = Event.first(id: id)
    new_image = resolve_image(params["cover_image_file"], params["cover_image"], event.cover_image)
    if new_image != event.cover_image
      ImageUpload.delete(event.cover_image)
    end
    event.update(permitted(params).merge(cover_image: new_image))
    sync_speakers(event, params["speakers"] || [])
    errors
  end

  def self.delete(id)
    event = Event.first(id: id)
    return unless event
    ImageUpload.delete(event.cover_image)
    event.speakers.each { |sp| ImageUpload.delete(sp.photo_url) }
    EventSpeaker.where(event_id: event.id).delete
    DB[:rsvps].where(event_id: event.id).delete
    event.delete
  end

  private

  # Returns uploaded path, or URL string, or existing value as fallback.
  def self.resolve_image(file, url, existing = nil)
    uploaded = ImageUpload.save(file)
    return uploaded if uploaded
    url_str = url.to_s.strip
    return url_str unless url_str.empty?
    existing
  end

  def self.validate(params)
    errors = {}
    errors[:title] = "Title is required" if params["title"].to_s.strip.empty?
    errors[:date]  = "Date is required"  if params["date"].to_s.strip.empty?
    errors
  end

  def self.permitted(params)
    {
      title:       params["title"].to_s.strip,
      description: params["description"].to_s.strip,
      event_type:  params["event_type"].to_s,
      date:        parse_time(params["date"]),
      end_date:    parse_time(params["end_date"]),
      location:    params["location"].to_s.strip,
      meeting_url: params["meeting_url"].to_s.strip,
      status:      params["status"] || "draft",
    }
  end

  def self.parse_time(val)
    return nil if val.to_s.strip.empty?
    Time.parse(val) rescue nil
  end

  def self.sync_speakers(event, speakers_params)
    old_speakers = EventSpeaker.where(event_id: event.id).all
    old_speakers.each { |sp| ImageUpload.delete(sp.photo_url) }
    EventSpeaker.where(event_id: event.id).delete

    speakers = speakers_params.is_a?(Hash) ? speakers_params.values : Array(speakers_params)
    speakers.each do |sp|
      next if sp["name"].to_s.strip.empty?
      photo = resolve_image(sp["photo_file"], sp["photo_url"])
      EventSpeaker.create(
        event_id:  event.id,
        name:      sp["name"].to_s.strip,
        bio:       sp["bio"].to_s.strip,
        photo_url: photo.to_s
      )
    end
  end
end
