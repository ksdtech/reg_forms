migration 4, :create_guardian_students do
  up do
    create_table :guardian_students do
      column :id, DataMapper::Property::Integer, :serial => true
      column :guardian_id, DataMapper::Property::Integer
      column :student_id, DataMapper::Property::Integer
      column :home_id, DataMapper::Property::Integer
      column :relationship, DataMapper::Property::String
      column :lives_with, DataMapper::Property::Boolean
    end
  end

  down do
    drop_table :guardian_students
  end
end
