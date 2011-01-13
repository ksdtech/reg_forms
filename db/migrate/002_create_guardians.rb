migration 2, :create_guardians do
  up do
    create_table :guardians do
      column :id, DataMapper::Property::Integer, :serial => true
      column :first_name, DataMapper::Property::String
      column :last_name, DataMapper::Property::String
      column :geo_hash, DataMapper::Property::String
      column :email, DataMapper::Property::String
      column :username, DataMapper::Property::String
      column :password, DataMapper::Property::String
      column :home_phone, DataMapper::Property::String
      column :work_phone, DataMapper::Property::String
      column :cell_phone, DataMapper::Property::String
    end
  end

  down do
    drop_table :guardians
  end
end
