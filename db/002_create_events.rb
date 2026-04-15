Sequel.migration do
  up do
    create_table?(:events) do
      column :id, :uuid, primary_key: true, default: Sequel.function(:gen_random_uuid)
      String  :title,       null: false
      String  :description, text: true
      String  :type
      DateTime :date
      String  :location
      String  :cover_image
      String  :status,      default: "draft"
      column  :created_by, :uuid
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
  down { drop_table(:events) }
end
