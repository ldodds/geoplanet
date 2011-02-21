$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'csv'
require 'Util'

if !File.exists?(ARGV[1])
  Dir.mkdir( ARGV[1] )  
end

count = 0

out = File.new( File.join(ARGV[1], "geoplanet-adjacencies.nt"), "w")

CSV.open(ARGV[0], "r", "\t") do |row|
  
  if row[0] != "Place_WOE_ID"
    count = count + 1
      
    uri = Util.canonicalize( "/place/#{ row[0] }")
    neighbour = Util.canonicalize( "/place/#{ row[2] }")
    
    triples = "<#{uri}> <http://data.ordnancesurvey.co.uk/ontology/spatialrelations/borders> <#{neighbour}>.\n"
    out.write( triples  )
      
    #exit if count == BATCH_SIZE
  end
  
end

out.close()
