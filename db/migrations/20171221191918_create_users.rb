Hanami::Model.migration do
  change do
    create_table :users do
      primary_key :id

      column :full_name, String
      column :email, String
      column :password, String
    end
  end
end
