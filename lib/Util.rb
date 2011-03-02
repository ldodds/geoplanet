module Util

  LANGUAGES = {
    "ARA" => "aa",
    "CHI" => "zh",
    "CZE" => "cs",
    "DAN" => "da",
    "DUT" => "nl",  
    "ENG" => "en",
    "FIN" => "fi",
    "FRE" => "fr",
    "GER" => "de",
    "HUN" => "hu",
    "ITA" => "it",
    "JPN" => "ja",
    "KOR" => "ko",
    "NOR" => "no",
    "POL" => "pl",
    "POR" => "pt",
    "RUM" => "ro",
    "SPA" => "es",
    "SWE" => "sv"
  }
  
  def Util.lang(lang)
    return LANGUAGES[lang]
  end
  
  def Util.rdf_root
    return "<rdf:RDF     
    xmlns:dc=\"http://purl.org/dc/terms/\"\n\
    xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n\
    xmlns:foaf=\"http://xmlns.com/foaf/0.1/\"\n\
    xmlns:owl=\"http://www.w3.org/2002/07/owl#\"\n\
    xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n\
    xmlns:xsd=\"http://www.w3.org/2001/XMLSchema#\"\n\
    xmlns:geop=\"http://purl.org/net/schemas/geop/\">\n\n"    
  end
  
  def Util.rdf_end
    return "\n\n</rdf:RDF>"  
  end 
 
  def Util.escape_xml(s)
    escaped = s.dup    
    escaped.gsub!("&", "&amp;")
    escaped.gsub!("<", "&lt;")
    escaped.gsub!(">", "&gt;")
            
    return escaped    
  end
  

  #Util code for cleaning up whitespace, newlines, etc
  def Util.clean_ws(s)
    cleaned = s.gsub /^\r\n/, ""
    cleaned.gsub! /\n/, ""    
    cleaned.gsub! /\s{2,}/, " "
    cleaned.gsub! /^\s/, ""
    
    illegal = /\x00|\x01|\x02|\x03|\x04|\x05|\x06|\x07|\x08|\x0B|
    \x0C|\x0E|\x0F|\x10|\x11|\x12|\x13|\x14|\x15|\x16|\x17|\x18|\x19|\x1A|
    \x1B|\x1C|\x1D|\x1E|\x1F/
    
    cleaned.gsub! illegal, " "    
    if cleaned == "" or cleaned == " "
      return nil
    end
    return cleaned
  end  
  
  
  def Util.slug(s)
    normalized = s.downcase
    normalized.gsub! /\s+/, "-"
    normalized.gsub! /\(|\)/, ""
    
    normalized.gsub! /&/, ""
    normalized.gsub! /\?/, ""
    normalized.gsub! /\=/, ""
    
    return normalized    
  end
   

  def Util.escape_xml(s)
    if s == nil
      return s
    end
    
    escaped = s.dup
    
    escaped.gsub!("&", "&amp;")
    escaped.gsub!("<", "&lt;")
    escaped.gsub!(">", "&gt;")
            
    return escaped
    
  end

  def Util.clean_escape(s)
    return escape_xml( clean_ws(s) ) 
  end  
    
  def Util.canonicalize(path)
    if path.start_with?("http")
      return path
    end  
    return "http://data.kasabi.com/dataset/yahoo-geoplanet#{path}"
  end
      
  def Util.readable_label(name)
    readable = name.split(/(?=[A-Z])/).join(' ')
    return readable.split(" ").map { |word| word.capitalize }.join(" ")
  end
  
end