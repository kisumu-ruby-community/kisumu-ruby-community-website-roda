Sequel.migration do
  up do
    create_table?(:users) do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)
      String :name
      String :email, unique: true, null: false
      String :password_digest
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    drop_table(:users)
  end
end
