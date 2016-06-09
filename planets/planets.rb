class Planets
  def initialize()
  end


end

def getPlanets()
  planetsList = []

  i = 1

  while i < 8 do 

    puts("Loop ") 
    url_page = 'http://swapi.co/api/planets/?page=' + i.to_s
    puts url_page
    planets = HTTParty.get(url_page)['results']
    #puts "---Characters---"
    #puts characters

    planets.each do |planet|
      puts planet['name']
      planetsList << planet
    end 

    i += 1

  end 
  #puts charactersList
  return planetsList
end

def getPlanet(name)
  planets = getPlanets()
  planets.each do |planet|
    puts planet['name']
    if name.downcase == planet['name'].downcase
      return "What do you want to know about " + planet['name'] + "?" 
    end 
  end 
  return "Sorry. I cannot find that planet."
end

def getPlanetOrbitalPeriod(name)
  planets = getPlanets()
  planets.each do |planet|
    if name.downcase == planet['name'].downcase
      return "The orbital period of " + name + " is " + planet['orbital_period'] + ' days. Anything else?'
    end  
  end 
  return "Sorry. I cannot find that planet's orbital period."
end 

def getPlanetClimate(name)
  planets = getPlanets()
  planets.each do |planet|
    if name.downcase == planet['name'].downcase
      return "The climate of " + name + " is " + planet['climate'] + '. Anything else?'
    end  
  end 
  return "Sorry. I cannot find that planet's climate."
end 

def getPlanetTerrain(name)
  planets = getPlanets()
  planets.each do |planet|
    if name.downcase == planet['name'].downcase
      return "The terrain of " + name + " is " + planet['terrain'] + '. Anything else?'
    end  
  end 
  return "Sorry. I cannot find that planet's terrain."
end 

def getPlanetPopulation(name)
  planets = getPlanets()
  planets.each do |planet|
    if name.downcase == planet['name'].downcase
      return "The population of " + name + " is " + planet['population'] + '. Anything else?'
    end  
  end 
  return "Sorry. I cannot find that planet's population."
end 

def getPlanetResidents(name)
  planets = getPlanets()
  planets.each do |planet|
    #puts character['name']
    if name.downcase == planet['name'].downcase
      residents = planet['residents']
      puts residents

      

      count = residents.length

      if count == 0
        result = "There are no residents for this planet."
      else
        result = name + " has the following residents: "
      i = 0

      residents.each do |resident|
        if i == count - 1 and count > 1
          puts result 
          result += " and " + HTTParty.get(resident)['name']
        else
          puts "---Resident---"
          puts resident
          person = HTTParty.get(resident)['name'] 
          puts person
          result += person + ", "
        end 
        i += 1
      end 
      
      return result + '. Anything else?'
      end 
    end 
  end 

  return "Sorry. I cannot find the residents of this planet."
end
