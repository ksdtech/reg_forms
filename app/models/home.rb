require 'json'
require 'open-uri'

class Home
  include DataMapper::Resource 

  # property <name>, <type>
  property :id, Integer, :key => true
  property :street_orig, String
  property :street, String
  property :city, String
  property :state, String
  property :zip, String
  property :home_phone, String
  property :geo_hash, String
  
  has n, :guardian_students
  has n, :students, :through => :guardian_students
  has n, :guardians, :through => :guardian_students
  
  class << self
    def geocoding_results(street, city, state, zip)
      street = (street || '').strip
      city = (city || '').strip
      return nil if street.empty? || city.empty?
      state = (state || 'CA').strip
      zip = (zip || '').strip
      location = "#{street}, #{city}, #{state} #{zip}".strip
      url = "http://where.yahooapis.com/geocode?location=#{URI.escape(location)}&appid=#{configatron.yahoo_appid}&flags=JS"
      response = JSON.parse(open(url).read)
      geo = response['ResultSet']['Results'][0] rescue nil
      
      # We say it's good if the address number matches, even if the street is wrong
      # 87 Address match with street match
      # 86 Address mismatch with street match
      # 85 Address match with street mismatch
      # 84 Address mismatch with street mismatch
      geo && !geo['line1'].empty? && [85, 87].include?(geo['quality']) ? geo : nil
    end
  end
end