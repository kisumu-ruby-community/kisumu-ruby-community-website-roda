Sequel.migration do
  up do
    create_table?(:rsvps) do
      column :id,       :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)
      column :event_id, :uuid, null: false
      column :user_id,  :uuid, null: false
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
  down { drop_table(:rsvps) }
end
