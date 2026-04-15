Sequel.migration do
  up do
    create_table?(:resources) do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)
      String :title, null: false
      String :url, null: false
      String :category
      column :submitted_by, :uuid
      TrueClass :is_approved, default: false
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    drop_table(:resources)
  end
end
