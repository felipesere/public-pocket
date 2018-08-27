Sequel.migration do
  up do
    create_table(:meta_data) do
      primary_key :id
      TrueClass :successful
      DateTime :timestamp
      Integer :number_of_articles
    end
  end

  down do
    drop_table(:meta_data)
  end
end
