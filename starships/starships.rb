class Starships
  def initialize()
  end


end

def getStarships()
  starshipsList = []

  i = 1

  while i < 5 do 

    puts("Loop ") 
    url_page = 'http://swapi.co/api/starships/?page=' + i.to_s
    puts url_page
    starships = HTTParty.get(url_page)['results']
    #puts "---Characters---"
    #puts characters

    starships.each do |starship|
      puts starship['name']
      starshipsList << starship
    end 

    i += 1

  end 
  #puts charactersList
  return starshipsList
end

def getStarship(name)
  	starships = getStarships()
  	starships.each do |starship|
    puts starship['name']
    if name == starship['name']
      return "What do you want to know about " + starship['name'] + "?" 
    end 
  end 
  return "Sorry. I cannot find that starship."
end

def getStarshipManufacturer(name)
	starships = getStarships()
  	starships.each do |starship|
    puts starship['name']
    if name == starship['name']
      return "The manufacturer of " + name + " is " + starship['manufacturer'] + "?" 
    end 
  end 
  return "Sorry. I cannot find the manufacturer of that starship."
end

def getStarshipLength(name)
	starships = getStarships()
  	starships.each do |starship|
    puts starship['name']
    if name == starship['name']
      return name + " is " + starship['length'] + " meters long." 
    end 
  end 
  return "Sorry. I cannot find the length of that starship."
end