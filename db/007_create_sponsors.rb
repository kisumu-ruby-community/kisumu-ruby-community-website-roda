Sequel.migration do
  up do
    create_table?(:sponsors) do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)
      String :name, null: false
      String :logo_url
      String :website_url
      TrueClass :is_active, default: true
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    drop_table(:sponsors)
  end
end
