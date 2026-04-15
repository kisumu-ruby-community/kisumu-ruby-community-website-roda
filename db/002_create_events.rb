Sequel.migration do
  up do
    create_table?(:events) do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)
      String :title, null: false
      Text :description
      String :event_type
      DateTime :date
      String :location
      String :cover_image
      String :status, default: "upcoming"
      column :created_by, :uuid
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    drop_table(:events)
  end
end
