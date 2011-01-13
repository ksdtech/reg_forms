class Guardian
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :first_name, String
  property :last_name, String
  property :geo_hash, String
  property :email, String
  property :username, String
  property :password, String
  property :home_phone, String
  property :work_phone, String
  property :cell_phone, String
  
  has n, :guardian_students
  has n, :students, :through => :guardian_students
  has n, :homes, :through => :guardian_students
  
  class << self
    def match_or_create_by_name_and_address(first_name, last_name, geo_hash)
      first_name = (first_name || '').strip
      last_name = (last_name || '').strip
      geo_hash = (geo_hash || '').strip
      return nil if first_name.empty? || last_name.empty? || geo_hash.empty?
      g = Guardian.first(:first_name => first_name, :last_name => last_name, :geo_hash => geo_hash)
      if g
        puts "found guardian #{g.inspect}"
      else
        g = Guardian.create(:first_name => first_name, :last_name => last_name, :geo_hash => geo_hash)
      end
      g
    end
  end
end