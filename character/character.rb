
class Character
  def initialize()
  end


end

def queryStarWarsForCharacters(name)
  url = 'http://swapi.co/api/people'
  puts url 
  data = HTTParty.get(url)['results']

  pages = []

  i = 1

  while i < 5 do 

    puts("Loop ")
    i += 1 
    url_page = 'http://swapi.co/api/people/?page=' + i.to_s
    puts url_page
    characters = HTTParty.get(url)['results']
    #puts characters

    pages += [characters]

  end 

  #puts pages


  # loop over data in json array
  data.each do |character|
    puts character['name']
    if name == character['name']
      return character['name']
    else
      return "Sorry. I cannot find that character."
    end 
  end 
end 


def getAllCharacters()
  charactersList = []

  i = 1

  while i < 8 do 

    puts("Loop ") 
    url_page = 'http://swapi.co/api/people/?page=' + i.to_s
    puts url_page
    characters = HTTParty.get(url_page)['results']
    #puts "---Characters---"
    #puts characters

    characters.each do |character|
      puts character['name']
      charactersList << character
    end 

    i += 1

  end 
  #puts charactersList
  return charactersList
end 


def getCharacterName(characters, name)
  puts name
  characters.each do |character|
    puts character['name']
    if name == character['name']
      return "What do you want to know about " + name + " ?"
    end 
  end 
  return "Sorry. I cannot find that character."
end 


def getCharacterHeight(characters, name)
  #puts name
  characters.each do |character|
    #puts character['name']
    if name == character['name']
      return "The height of " + name + " is " + character['height'] + ' centimeters. Anything else?'
    end 
  end 
  return "Sorry. I cannot find that character's height."
end 

def getCharacterHairColor(characters, name)
  characters.each do |character|
    #puts character['name']
    if name == character['name']
      return "The hair color of " + name + " is " + character['hair_color'] + '. Anything else?'
    end 
  end 
  return "Sorry. I cannot find that character's height."
end

def getCharacterHomeWorld(characters, name)

  characters.each do |character|
    #puts character['name']
    if name == character['name']
      url_page = character['homeworld']
      #puts url_page
      homeWorld = HTTParty.get(url_page)['name']
      #puts homeWorld
      return "The home world of " + name + " is " + homeWorld + '. Anything else?'
    end 
  end 

  return "Sorry. I cannot find the character's home world."
end

def getCharacterFilms(characters, name)

  characters.each do |character|
    #puts character['name']
    if name == character['name']
      films = character['films']
      puts films

      result = name + " has appeared in "

      count = films.length
      i = 0

      films.each do |film|
        if i == count - 1 and count > 1
          puts result 
          result += " and " + HTTParty.get(film)['title']
        else
          puts "---Film---"
          puts film
          title = HTTParty.get(film)['title'] 
          puts title
          result += title + ", "
        end 
        i += 1
      end 
      
      return result + '. Anything else?'
    end 
  end 

  return "Sorry. I cannot find the films the character has been in."
end


def getCharacterInfoString(characters, name)
  puts name
  characters.each do |character|
    puts character['name']
    if name == character['name']
      return "You wanted to know about " + character['name'] + ". 
      The character is " + character['height'] + " centimeters tall and weighs " + character['mass'] + " kilograms." + " 
      The character has " + character['hair_color'] + " hair and " + character['skin_color'] + " skin color."
    end 
  end 
  return "Sorry. I cannot find that character."
end 


def getCharacterInfoField(characters, name, option)
  puts name 
  puts option
  characters.each do |character|
    #puts character['name']
    if name == character['name']
      return character[option]
    end 
  end 
  return "Sorry. I cannot find that character."
end 


def getCharacterHairColor(characters, name)
  #puts name
  characters.each do |character|
    #puts character['name']
    if name == character['name']
      return "The hair color of " + name + " is " + character['hair_color'] + '. Anything else?'
    end 
  end 
  return "Sorry. I cannot find that character's hair color."
end 

def getCharacterSkinColor(characters, name)
  #puts name
  characters.each do |character|
    #puts character['name']
    if name == character['name']
      return "The skin color of " + name + " is " + character['skin_color'] + '. Anything else?'
    end 
  end 
  return "Sorry. I cannot find that character's skin color."
end 

def getCharacterBirthYear(characters, name)
  #puts name
  characters.each do |character|
    #puts character['name']
    if name == character['name']
      return "The birth year of " + name + " is " + character['birth_year'] + '. Anything else?'
    end 
  end 
  return "Sorry. I cannot find that character's birth year."
end 

