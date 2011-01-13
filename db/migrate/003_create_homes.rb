migration 3, :create_homes do
  up do
    create_table :homes do
      column :id, DataMapper::Property::Integer, :key => true
      column :street_orig, DataMapper::Property::String
      column :street, DataMapper::Property::String
      column :city, DataMapper::Property::String
      column :state, DataMapper::Property::String
      column :zip, DataMapper::Property::String
      column :geo_hash, DataMapper::Property::String
      column :home_phone, DataMapper::Property::String
    end
  end

  down do
    drop_table :homes
  end
end
