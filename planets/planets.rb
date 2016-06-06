
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
    if name == planet['name']
      return "What do you want to know about " + planet['name'] + "?" 
    end 
  end 
  return "Sorry. I cannot find that planet."
end

def getPlanetOrbitalPeriod(name)
  planets = getPlanets()
  planets.each do |planet|
    if name == planet['name']
      return "The orbital period of " + name + " is " + planet['orbital_period'] + ' days. Anything else?'
    end  
  end 
  return "Sorry. I cannot find that planet's orbital period."
end 
