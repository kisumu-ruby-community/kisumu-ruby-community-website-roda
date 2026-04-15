class EventsService
  def self.index
    all     = Event.order(:date).all
    upcoming = all.select(&:upcoming?)
    past     = all.reject(&:upcoming?)
    { title: "Events", upcoming: upcoming, past: past }
  end

  def self.show(id, current_user = nil)
    event = Event.first(id: id.to_s)
    return { title: "Event not found", event: nil, speakers: [], rsvp_count: 0, user_rsvpd: false } unless event

    speakers   = EventSpeaker.where(event_id: event.id).all
    rsvp_count = DB[:rsvps].where(event_id: event.id).count
    user_rsvpd = current_user && DB[:rsvps].first(event_id: event.id, user_id: current_user.id)

    { title: event.title, event: event, speakers: speakers,
      rsvp_count: rsvp_count, user_rsvpd: !!user_rsvpd }
  end
end
