Sequel.migration do
  up do
    create_table?(:event_speakers) do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)
      column :event_id, :uuid, null: false
      String :name,      null: false
      String :bio,       text: true
      String :photo_url
    end
  end
  down { drop_table(:event_speakers) }
end
