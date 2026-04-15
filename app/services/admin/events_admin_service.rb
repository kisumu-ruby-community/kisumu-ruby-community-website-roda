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
      created_by: user.id,
      created_at: Time.now
    )
    event = Event.create(attrs)
    sync_speakers(event, params["speakers"] || [])
    event
  end

  def self.update(id, params)
    errors = validate(params)
    return errors unless errors.empty?
    event = Event.first(id: id)
    event.update(permitted(params))
    sync_speakers(event, params["speakers"] || [])
    errors
  end

  def self.delete(id)
    event = Event.first(id: id)
    return unless event
    EventSpeaker.where(event_id: event.id).delete
    DB[:rsvps].where(event_id: event.id).delete
    event.delete
  end

  private

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
      cover_image: params["cover_image"].to_s.strip,
      status:      params["status"] || "draft",
    }
  end

  def self.parse_time(val)
    return nil if val.to_s.strip.empty?
    Time.parse(val) rescue nil
  end

  def self.sync_speakers(event, speakers_params)
    EventSpeaker.where(event_id: event.id).delete
    speakers = speakers_params.is_a?(Hash) ? speakers_params.values : Array(speakers_params)
    speakers.each do |sp|
      next if sp["name"].to_s.strip.empty?
      EventSpeaker.create(
        event_id:  event.id,
        name:      sp["name"].to_s.strip,
        bio:       sp["bio"].to_s.strip,
        photo_url: sp["photo_url"].to_s.strip
      )
    end
  end
end
