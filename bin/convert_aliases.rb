$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'Alias'
require 'csv'

if !File.exists?(ARGV[1])
  Dir.mkdir( ARGV[1] )  
end

count = 0

RDF::NTriples::Writer.open( File.join(ARGV[1], "geoplanet-aliases.nt") ) do |writer|

  CSV.open(ARGV[0], "r", "\t") do |row|
  
    if row[0] != "WOE_ID"
      
      count = count + 1
            
      a = Alias.new(row)
      statements = a.statements()
      
      statements.each do |stmt|
        writer << stmt
      end
      
#      exit if count == 70

    end
    
  end

end
