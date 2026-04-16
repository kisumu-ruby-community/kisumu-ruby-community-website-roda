require_relative "../services/events_service"

module Routes
  class EventsRoute
    def self.call(r)
      EventsService.index
    end

    def self.show(r, id, current_user = nil)
      EventsService.show(id, current_user)
    end

    def self.rsvp(r, id, user)
      DB[:rsvps].insert_conflict(target: [:event_id, :user_id]).insert(
        id:         Sequel.function(:gen_random_uuid),
        event_id:   id.to_s,
        user_id:    user.id,
        created_at: Time.now
      )
    end

    def self.cancel_rsvp(r, id, user)
      DB[:rsvps].where(event_id: id.to_s, user_id: user.id).delete
    end
  end
end
