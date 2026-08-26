Sequel.migration do
  up do
    create_table?(:companies) do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)
      String :name, null: false
      String :website_url, null: false
      String :logo_url
      String :description, text: true
      String :country
      String :category
      TrueClass :is_approved, default: false
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    drop_table(:companies)
  end
end
