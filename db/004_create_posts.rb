Sequel.migration do
  up do
    create_table?(:posts) do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)
      String :title, null: false
      String :slug, unique: true, null: false
      Text :content
      column :author_id, :uuid
      String :cover_image
      String :tags
      String :status, default: "draft"
      DateTime :published_at
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    drop_table(:posts)
  end
end
