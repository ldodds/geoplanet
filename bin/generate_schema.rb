$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'Util'

types = []
File.open(ARGV[0], "r").each_line("\n") do |line|
  types << line.chomp
end

File.open("#{ARGV[1]}/types-schema.nt", "w") do |f|

  types.each do |type|
    f.puts "<http://data.kasabi.com/dataset/yahoo-geoplanet/schema/#{type}> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/1999/02/22-rdf-syntax-ns#Class>."
    f.puts "<http://data.kasabi.com/dataset/yahoo-geoplanet/schema/#{type}> <http://www.w3.org/2000/01/rdf-schema#label> \"#{Util.readable_label(type)}\"."
    f.puts "<http://data.kasabi.com/dataset/yahoo-geoplanet/schema/#{type}> <http://www.w3.org/2000/01/rdf-schema#subClassOf> <http://data.kasabi.com/dataset/geoplanet/schema/Place>."
    f.puts "<http://data.kasabi.com/dataset/yahoo-geoplanet/schema/#{type}> <http://www.w3.org/2000/01/rdf-schema#isDefinedBy> <http://data.kasabi.com/dataset/geoplanet/schema>."
    f.puts "<http://data.kasabi.com/dataset/yahoo-geoplanet/schema> <http://www.w3.org/2000/01/rdf-schema#seeAlso> <http://data.kasabi.com/dataset/geoplanet/schema/#{type}>."
  end

end