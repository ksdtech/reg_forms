class Student
  HOME    = [ :home_id, :street, :city, :state, :zip, :home_phone ].freeze
  HOME2   = [ :home2_id, :home2_street, :home2_city, :home2_state, :home2_zip, :home2_phone ].freeze
  MOTHER  = ([ :mother_first, :mother, :mother_home_phone, :mother_work_phone, :mother_cell, :mother_email, :mother_rel ] + HOME).freeze
  FATHER  = ([ :father_first, :father, :father_home_phone, :father_work_phone, :father_cell, :father_email, :father_rel ] + HOME).freeze
  MOTHER2 = ([ :mother2_first, :mother2_last, :mother2_home_phone, :mother2_work_phone, :mother2_cell, :mother2_email, :mother2_rel ] + HOME2).freeze
  FATHER2 = ([ :father2_first, :father2_last, :father2_home_phone, :father2_work_phone, :father2_cell, :father2_email, :father2_rel ] + HOME2).freeze
  GATTRS  = [ :first_name, :last_name, :home_phone, :work_phone, :cell_phone, :email ]
  GSATTRS = [ :relationship ]
  HATTRS  = [ :id, :street, :city, :state, :zip, :home_phone ]
  
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :student_number, Integer
  property :first_name, String
  property :middle_name, String
  property :last_name, String
  property :nickname, String
  property :gender, String
  property :dob, Date
  property :state_studentnumber, String
  property :schoolid, Integer
  property :enroll_status, Integer
  property :grade_level, Integer
  
  has n, :guardian_students
  has n, :guardians, :through => :guardian_students
  has n, :homes, :through => :guardian_students
  
  def add_guardian(attrs, guardian_attrs)
    gattrs = { }
    gsattrs = { } 
    hattrs = { }
    gs = nil
    i = 0
    GATTRS.each do |name| 
      gattrs[name]  = attrs[guardian_attrs[i]]
      i += 1
    end
    GSATTRS.each do |name| 
      gsattrs[name] = attrs[guardian_attrs[i]]
      i += 1
    end
    HATTRS.each do |name| 
      hattrs[name]  = attrs[guardian_attrs[i]]
      i += 1
    end
    # puts "gattrs: #{gattrs.inspect}"
    # puts "gsattrs: #{gsattrs.inspect}"
    # puts "hattrs: #{hattrs.inspect}"
    
    geo = Home.geocoding_results(hattrs[:street], hattrs[:city], hattrs[:state], hattrs[:zip])
    if geo
      hattrs[:street_orig] = hattrs[:street]
      hattrs[:geo_hash]    = geo['hash']
      hattrs[:street]      = geo['line1'] if geo['line1']
      hattrs[:city]        = geo['city'] if geo['city']
      hattrs[:state]       = geo['statecode'] if geo['statecode']
      hattrs[:zip]         = geo['postal'] if geo['postal']
      g = Guardian.match_or_create_by_name_and_address(gattrs[:first_name], gattrs[:last_name], hattrs[:geo_hash])
      if g
        g.attributes = gattrs
        g.save
        home_id = hattrs.delete(:id)
        h = Home.get(home_id) || Home.new
        h.id = home_id if h.new?
        h.attributes = hattrs
        h.save
        gs = self.guardian_students.first_or_create(:guardian_id => g.id)
        gs.attributes = gsattrs
        gs.home = h
        gs.save
      end
    else
    end
    gs
  end
  
  class << self
    def has_property?(name)
      [ :first_name, :middle_name, :last_name, :nickname,
        :gender, :dob, :student_number, :state_studentnumber, 
        :schoolid, :enroll_status, :grade_level ].include?(name.to_sym)
    end
    
    def import(fname, erase_first=true)
      if erase_first
        adapter = DataMapper.repository(:default).adapter
        adapter.execute("DELETE FROM guardian_students")
        adapter.execute("DELETE FROM guardians")
        adapter.execute("DELETE FROM students")
        adapter.execute("DELETE FROM homes")
      end

      fname = File.join(Padrino.root, 'data', fname) unless fname[0,1] == '/'
      UnquotedCSV.foreach(fname, 
        :col_sep => "\t", :row_sep => "\n",
        :headers => true, :header_converters => :symbol) do |row|
        # begin
          attrs = row.to_hash
          sn = attrs[:student_number].to_i
          attrs[:home_id] = 0 if attrs[:home_id].nil?
          if attrs[:home_id].to_i == 0
            puts "no primary family for student #{sn}"
            next
          end
          schoolid = (attrs[:schoolid] || 0).to_i
          if schoolid != 104 && schoolid != 103
            puts "invalid school for student #{sn}"
            next
          end
          # student_id = attrs.delete(:id).to_i
          student_attrs = attrs.reject { |k, v| !Student.has_property?(k) }
          
          # TODO run conversions from PowerSchool to DataMapper here
          
          s = Student.first_or_create(:student_number => sn)
          s.attributes = student_attrs
          s.save
          
          gs = s.add_guardian(attrs, Student::MOTHER)
          gs = s.add_guardian(attrs, Student::FATHER)
          gs = s.add_guardian(attrs, Student::MOTHER2)
          gs = s.add_guardian(attrs, Student::FATHER2)
        # rescue
        # end
      end
    end
  end
end
