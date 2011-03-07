require 'rubygems'
require 'rdf'
require 'Util'

class Place
  
  attr_reader :woeid
  attr_reader :isocountry
  attr_reader :preferred_name
  attr_reader :language_of_preferred_name
  attr_reader :place_type_code
  attr_reader :parent
  
  def initialize(row)
      @woeid = row[0]
      @isocountry = row[1]
      @preferred_name = row[2]
      @language_of_preferred_name = row[3]
      @place_type_code = row[4]
      @parent = row [5]  
  end
  
  def uri() 
    return Util.canonicalize("/place/#{@woeid}")
  end
  
  def parent_uri
    return Util.canonicalize("/place/#{@parent}")
  end
  
  def statements()
    
    statements = []
    geop = RDF::Vocabulary.new("http://data.kasabi.com/dataset/yahoo-geoplanet/schema/")
    spatial = RDF::Vocabulary.new("http://data.ordnancesurvey.co.uk/ontology/spatialrelations/")
    admin_geo = RDF::Vocabulary.new("http://statistics.data.gov.uk/def/administrative-geography/")    
     
    uri = RDF::URI.new( uri() )

    statements << RDF::Statement.new( uri, RDF::DC.identifier, RDF::Literal.new( @woeid ) )
    
    type = RDF::URI.new( "http://data.kasabi.com/dataset/yahoo-geoplanet/schema/#{@place_type_code}" )  
    statements << RDF::Statement.new( uri, RDF.type, type )
    statements << RDF::Statement.new( type, RDF::RDFS.subClassOf, geop.Place)
    
    statements << RDF::Statement.new( uri, geop.woeid, RDF::Literal.new( @woeid ) )
        
    lang = Util.lang(@language_of_preferred_name)
    if @language_of_preferred_name == nil
      puts "Unknown language #{@language_of_preferred_name}" unless @language_of_preferred_name == "UNK" 
      statements << RDF::Statement.new( uri, RDF::SKOS.prefLabel, RDF::Literal.new( @preferred_name ) )
    else
      statements << RDF::Statement.new( uri, RDF::SKOS.prefLabel, 
        RDF::Literal.new( @preferred_name, :language => lang ) )
    end
                    
    #containment relationship for hierarchy
    statements << RDF::Statement.new( RDF::URI.new( parent_uri() ), spatial.contains, uri  )
    
    #country that the place is in    
    country = RDF::URI.new( Util.canonicalize("/country/#{@isocountry.downcase}") )
    statements << RDF::Statement.new( country, RDF::DC.identifier, RDF::Literal.new(@isocountry) )
    statements << RDF::Statement.new( uri, admin_geo.country, country )        
    statements << RDF::Statement.new( country, RDF::OWL.sameAs, RDF::URI.new( "http://telegraphis.net/data/countries/#{@isocountry}##{@isocountry}") )
    statements << RDF::Statement.new( country, RDF::OWL.sameAs, RDF::URI.new( "http://dbpedia.org/resource/ISO_3166-1:#{@isocountry}") )
    
    if @place_type_code == "Country"
      #assert equivalence between the different uris for the country
      statements << RDF::Statement.new( uri, RDF::OWL.sameAs, country )
    end

    #If it's a uk "zip code"    
    if ( @place_type_code == "Zip" && @isocountry == "GB" )
      #"and matches the regex from http://regexlib.com/REDetails.aspx?regexp_id=260
      if @preferred_name.match(/^([A-PR-UWYZ0-9][A-HK-Y0-9][AEHMNPRTVXY0-9]?[ABEHMNPRVWXY0-9]? {1,2}[0-9][ABD-HJLN-UW-Z]{2}|GIR 0AA)$/)
        #then its a post code, so link to OS data
        postcodeunit = RDF::URI.new( "http://data.ordnancesurvey.co.uk/id/postcodeunit/#{@preferred_name.gsub(" ", "")}")
        statements << RDF::Statement.new( uri, RDF::OWL.sameAs, postcodeunit )
        statements << RDF::Statement.new( postcodeunit, RDF::OWL.sameAs, uri )
      end
    end
    
    
    
    return statements
    
  end
  
end