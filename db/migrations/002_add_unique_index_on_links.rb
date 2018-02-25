Sequel.migration do
  up do
    alter_table(:articles) do
      add_index :link, unique: true
    end
  end

  down do
    alter_table(:articles) do
      remove_index :link
    end
  end
end
