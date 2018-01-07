Hanami::Model.migration do
  change do
    create_table :contracts do
      primary_key :id
      foreign_key :user_id, :users, on_delete: :cascade, null: false

      column :vendor, String
      column :starts_on, DateTime
      column :ends_on, DateTime
    end
  end
end
