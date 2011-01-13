migration 1, :create_students do
  up do
    create_table :students do
      column :id, DataMapper::Property::Integer, :serial => true
      column :student_number, DataMapper::Property::Integer
      column :first_name, DataMapper::Property::String
      column :middle_name, DataMapper::Property::String
      column :last_name, DataMapper::Property::String
      column :nickname, DataMapper::Property::String
      column :gender, DataMapper::Property::String
      column :dob, DataMapper::Property::Date
      column :state_studentnumber, DataMapper::Property::String
      column :schoolid, DataMapper::Property::Integer
      column :enroll_status, DataMapper::Property::Integer
      column :grade_level, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :students
  end
end
