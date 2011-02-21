require 'rubygems'
require 'rdf'
require 'Util'

class Alias
  
  def initialize(row)
    @woeid = row[0]
    @name = row[1]
    @name_type = row[2]
    @language = row[3]
    
    
  end
  
  def uri() 
    return Util.canonicalize("/place/#{@woeid}")
  end
  
  def statements
    statements = []      
    skosxl = RDF::Vocabulary.new("http://www.w3.org/2008/05/skos-xl#")
    uri = RDF::URI.new( uri() )
    
    lang = Util.lang(@language)
    
    case @name_type
    when "P" then
      #P is a preferred English name
      statements << RDF::Statement.new( uri, RDF::SKOS.prefLabel, 
        RDF::Literal.new( @name, :language => "en" ) )      
    when "Q" then
      #Q is a preferred name (in other languages)
      statements << RDF::Statement.new( uri, RDF::SKOS.prefLabel, 
        RDF::Literal.new( @name, :language => lang ) )            
    when "V" then
      #V is a well-known (but unofficial) variant 
      #for the place (e.g. "New York City" for New York)
      statements << RDF::Statement.new( uri, RDF::SKOS.altLabel, 
        RDF::Literal.new( @name, :language => lang ) )      
    when "S" then
      #S is either a synonym or a colloquial name 
      #for the place (e.g. "Big Apple" for New York), or 
      #a version of the name which is stripped of accent characters.
      statements << RDF::Statement.new( uri, RDF::SKOS.altLabel, 
        RDF::Literal.new( @name, :language => lang ) )      
    when "A" then
      #A is an abbreviation or code for the place (e.g. "NYC" for New York)
      statements << RDF::Statement.new( uri, RDF::SKOS.hiddenLabel, 
        RDF::Literal.new( @name, :language => lang ) )                  
    else
      puts "Unknown name type: #{@name_type}"
    end  
              
    return statements
  end
  
end