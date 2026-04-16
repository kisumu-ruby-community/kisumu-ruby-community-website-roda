class EventSpeaker < Sequel::Model
  many_to_one :event
end
