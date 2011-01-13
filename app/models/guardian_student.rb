class GuardianStudent
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :relationship, String
  property :lives_with, Boolean
  property :guardian_id, Integer
  
  belongs_to :guardian
  belongs_to :student
  belongs_to :home
end