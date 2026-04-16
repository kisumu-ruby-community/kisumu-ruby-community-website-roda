Sequel.migration do
  up do
    alter_table(:users) do
      drop_column :password_digest
      add_column :github_id,       String, unique: true
      add_column :github_username, String
      add_column :avatar_url,      String
      add_column :role,            String, default: "visitor"
    end
  end
  down do
    alter_table(:users) do
      add_column :password_digest, String
      drop_column :github_id
      drop_column :github_username
      drop_column :avatar_url
      drop_column :role
    end
  end
end
