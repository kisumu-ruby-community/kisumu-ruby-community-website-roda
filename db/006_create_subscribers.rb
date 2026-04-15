Sequel.migration do
  up do
    create_table?(:subscribers) do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)
      String :email, unique: true, null: false
      DateTime :subscribed_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    drop_table(:subscribers)
  end
end
