Sequel.migration do
  up do
    alter_table(:events) do
      rename_column :type, :event_type
      add_column :end_date,    DateTime
      add_column :meeting_url, String
    end
    alter_table(:rsvps) do
      add_unique_constraint [:event_id, :user_id]
    end
  end
  down do
    alter_table(:events) do
      rename_column :event_type, :type
      drop_column :end_date
      drop_column :meeting_url
    end
  end
end
