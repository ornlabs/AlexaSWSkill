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
    nameLower = name.downcase
    nameLower = checkForSpecialCase(nameLower)
    if nameLower == starship['name'].downcase
      return "What do you want to know about " + starship['name'] + "?" 
    end 
  end 
  return "Sorry. I cannot find that starship."
end

def getStarshipManufacturer(name)
	starships = getStarships()
  	starships.each do |starship|
    puts starship['name']
    if name.downcase == starship['name'].downcase
      return "The manufacturer of " + name + " is " + starship['manufacturer'] + "." 
    end 
  end 
  return "Sorry. I cannot find the manufacturer of that starship."
end

def getStarshipLength(name)
	starships = getStarships()
  	starships.each do |starship|
    puts starship['name']
    if name.downcase == starship['name'].downcase
      return name + " is " + starship['length'] + " meters long." 
    end 
  end 
  return "Sorry. I cannot find the length of that starship."
end

def getStarshipClass(name)
	starships = getStarships()
  	starships.each do |starship|
    puts starship['name']
    if name.downcase == starship['name'].downcase
      return name + " belongs to the " + starship['starship_class'] + " class." 
    end 
  end 
  return "Sorry. I cannot find the class of that starship."
end

def getStarshipCost(name)
	starships = getStarships()
  	starships.each do |starship|
    puts starship['name']
    if name.downcase == starship['name'].downcase
    	if starship['cost_in_credits'] == "unknown"
    		return "The cost of the star ship is unknown."
    	else
			return name + " costs " + starship['cost_in_credits'] + " credits."
		end 
    end 
  end 
  return "Sorry. I cannot find the cost of that starship."
end


def getStarshipSpeed(name)
	starships = getStarships()
  	starships.each do |starship|
    puts starship['name']
    if name.downcase == starship['name'].downcase
    	if starship['max_atmosphering_speed'] == "n/a"
    		return "This star ship has no max atmosphering speed."
    	else
    		return name + " reaches a maximum atmosphering speed of " + starship['max_atmosphering_speed'] + " km/s." 
    	end 
    end 
  end 
  return "Sorry. I cannot find the class of that starship."
end


def checkForSpecialCase(nameLower)
  if nameLower == 'x wing' 
    return 'x-wing'
  elsif nameLower == 'sentinel class landing craft'
    return 'sentinel-class landing craft'
  elsif nameLower == 'y wing'
    return 'y-wing'
  end 
end 