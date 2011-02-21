$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'Place'
require 'csv'

if !File.exists?(ARGV[1])
  Dir.mkdir( ARGV[1] )  
end

count = 0

RDF::NTriples::Writer.open( File.join(ARGV[1], "geoplanet-places.nt") ) do |writer|

  CSV.open(ARGV[0], "r", "\t") do |row|
  
    if row[0] != "WOE_ID"
      
      count = count + 1
            
      place = Place.new(row)
      statements = place.statements()
      
      statements.each do |stmt|
        writer << stmt
      end
      
#      exit if count == 70

    end
    
  end

end
