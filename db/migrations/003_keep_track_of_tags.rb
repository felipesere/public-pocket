Sequel.migration do
  up do
    alter_table(:articles) do
      add_column :tags, "text[]", default: []
    end
  end

  down do
    alter_table(:articles) do
      remove_column :tags
    end
  end
end
