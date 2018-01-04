Hanami::Model.migration do
  change do
    create_table :users do
      primary_key :id

      column :full_name, String
      column :email, String, unique: true
      column :password, String
      column :token, String
    end
  end
end
