require 'rubygems'
require 'rake'
require 'rake/clean'
require 'pho'

CACHE_DIR="data/cache"
RDF_DIR="data/nt"

CLEAN.include ["#{RDF_DIR}/*.nt"]

#Helper function to create data dirs
def mkdirs()
  if !File.exists?(CACHE_DIR)
    Dir.mkdir(CACHE_DIR)
  end
  if !File.exists?(RDF_DIR)
    Dir.mkdir(RDF_DIR)
  end
end

task :init do
  mkdirs()      
end

task :download => [:init] do
  sh %{wget -O #{CACHE_DIR}/geoplanet_data.zip http://developer.yahoo.com/geo/geoplanet/data/getLatest.php}
  sh %{cd #{CACHE_DIR}; unzip *.zip; cd .. }
end

task :convert_places do
  sh %{ruby bin/convert_places.rb #{CACHE_DIR}/geoplanet_places_*.tsv #{RDF_DIR} }  
end

task :convert_adjacencies do
  sh %{ruby bin/convert_adjacencies.rb #{CACHE_DIR}/geoplanet_adjacencies_*.tsv #{RDF_DIR} }  
end

task :convert_aliases do
  sh %{ruby bin/convert_aliases.rb #{CACHE_DIR}/geoplanet_aliases_*.tsv #{RDF_DIR} }  
end

task :convert_static => [:init] do
    Dir.glob("etc/static/*.ttl").each do |src|
      sh %{rapper -i turtle -o ntriples #{src} >#{RDF_DIR}/#{File.basename(src, ".ttl")}.nt}
    end
end

task :generate_schema do
  sh %{cut -f5 #{CACHE_DIR}/geoplanet_places_*.tsv >/tmp/types.tmp }
  sh %{sort /tmp/types.tmp | uniq > #{CACHE_DIR}/types.txt }
  sh %{ruby bin/generate_schema.rb #{CACHE_DIR}/types.txt #{RDF_DIR} }
end

task :convert => [:init, :generate_schema, :convert_adjacencies, :convert_aliases, :convert_places, :convert_static]