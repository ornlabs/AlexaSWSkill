class Character
  def initialize()
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


def getCharacterName(name)
  puts name
  characters = getAllCharacters()
  characters.each do |character|
    puts character['name']
    if name == character['name']
      return "What do you want to know about " + name + " ?"
    end 
  end 
  return "Sorry. I cannot find that character."
end 


def getCharacterHeight(name)
  characters = getAllCharacters()
  characters.each do |character|
    if name == character['name']
      return "The height of " + name + " is " + character['height'] + ' centimeters. Anything else?'
    end 
  end 
  return "Sorry. I cannot find that character's height."
end 


def getCharacterHomeWorld(name)
  characters = getAllCharacters()
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

def getCharacterFilms(name)
  characters = getAllCharacters()
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


def getCharacterHairColor(name)
  characters = getAllCharacters()
  characters.each do |character|
    #puts character['name']
    if name == character['name']
      if character['hair_color'] == 'none'
        return name + " has no hair color."
      else
        return "The hair color of " + name + " is " + character['hair_color'] + '. Anything else?'
      end 
    end 
  end 
  return "Sorry. I cannot find that character's hair color."
end 

def getCharacterSkinColor(name)
  characters = getAllCharacters()
  characters.each do |character|
    #puts character['name']
    if name == character['name']
      return "The skin color of " + name + " is " + character['skin_color'] + '. Anything else?'
    end 
  end 
  return "Sorry. I cannot find that character's skin color."
end 

def getCharacterBirthYear(name)
  characters = getAllCharacters()
  characters.each do |character|
    #puts character['name']
    if name == character['name']
      return "The birth year of " + name + " is " + character['birth_year'] + '. Anything else?'
    end 
  end 
  return "Sorry. I cannot find that character's birth year."
end 

def getEyeColor(name)
  characters = getAllCharacters()
  characters.each do |character|
    #puts character['name']
    if name == character['name']
      return "The eye color of " + name + " is " + character['eye_color'] + '. Anything else?'
    end 
  end 
  return "Sorry. I cannot find that character's eye color."
end 

