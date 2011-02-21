types = []
File.open(ARGV[0], "r").each_line("\n") do |line|
  types << line.chomp
end

File.open("#{ARGV[1]}/types-schema.nt", "w") do |f|

  types.each do |type|
    f.puts "<http://purl.org/net/schemas/geop/#{type}> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/1999/02/22-rdf-syntax-ns#Class>."
    f.puts "<http://purl.org/net/schemas/geop/#{type}> <http://www.w3.org/2000/01/rdf-schema#label> \"#{Util.readable_label(type)}\"."
    f.puts "<http://purl.org/net/schemas/geop/#{type}> <http://www.w3.org/2000/01/rdf-schema#subClassOf> <http://data.kasabi.com/dataset/geoplanet/schema/Place>."
    f.puts "<http://purl.org/net/schemas/geop/#{type}> <http://www.w3.org/2000/01/rdf-schema#isDefinedBy> <http://data.kasabi.com/dataset/geoplanet/schema>."
    f.puts "<http://data.kasabi.com/dataset/geoplanet/schema> <http://www.w3.org/2000/01/rdf-schema#seeAlso> <http://purl.org/net/schemas/geop/#{type}>."
  end

end