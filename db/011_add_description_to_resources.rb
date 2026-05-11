Sequel.migration do
  up do
    alter_table(:resources) do
      add_column :description, String, text: true
    end
  end

  down do
    alter_table(:resources) do
      drop_column :description
    end
  end
end
