require 'sinatra'
require 'json'
require 'net/http'
require 'httparty'
require 'digest/md5'
require 'rack/env'
#require './marvel/marvel'
require './character/character'
require './films/films'
require './response_object/response_object'
require './planets/planets'
require './starships/starships'
#use Rack::Env, envfile: 'config/local_env.yml'

post '/' do
  request.body.rewind
  @request_payload = JSON.parse request.body.read

  puts "---REQUEST PAYLOAD---"
  puts @request_payload

  puts "---INTENT---"
  intent = @request_payload['request']['intent']['name'] 
  puts intent

  sessionAttribute = "none"

  puts "---SESSION---"
  if defined?(@request_payload['session']['attributes']['starship'])
    sessionAttribute = "starship"
  end 
  puts sessionAttribute

  # type == LaunchRequest
  if @request_payload['request']['type'] == 'LaunchRequest'
    '{
      "version": "1.0",
      "response": {
        "outputSpeech": {
          "type": "PlainText",
          "text": "Go."
        },
        "shouldEndSession": true
      }
    }'
  elsif intent == 'AMAZON.CancelIntent'

    
    response = returnJSON("Goodbye. See you later...", true)
    JSON.generate(response)

  elsif intent == 'movie'
    puts "---NEW SESSION---"
    @input = @request_payload['request']['intent']['slots']['film']['value']
    puts @input

    film = isMovie(@input)
    if film != "Sorry. I cannot find that film."
      result = getOpeningCrawl(film)
    else
      result = "I don't know what you are talking about. Try again."
    end 
    puts "---Film Crawl---"
    puts result
    response = storeSessionAttributeForMovie(@input, result, true, false)

    puts response
    JSON.generate(response)
  elsif intent == 'character'

    puts "---NEW SESSION---"
    @input = @request_payload['request']['intent']['slots']['person']['value']
    puts @input

    character = getCharacterName(@input)     
    if character != "Sorry. I cannot find that character."
      result = character
    else
      result = "I don't know what you are talking about. Try again."
    end 

    response = storeSessionAttribute(@input, result, true, false)
    JSON.generate(response)
  elsif intent == 'planets'

    puts "---NEW SESSION---"
    @input = @request_payload['request']['intent']['slots']['planet']['value']
    puts @input

    planet = getPlanet(@input)
    if planet != "Sorry. I cannot find that planet."
      result = character
    else
      result = "I don't know what you are talking about. Try again."
    end 
    response = storeSessionAttributeForPlanet(@input, planet, true, false)
    JSON.generate(response)
  # check that the session attribute is there and that slots does not exist
  # this allows users to switch and ask for a different character
elsif intent == 'starships'

    puts "---NEW SESSION---"
    @input = @request_payload['request']['intent']['slots']['starship']['value']
    puts @input

    starship = getStarship(@input)
    if starship != "Sorry. I cannot find that starship."
      result = character
    else
      result = "I don't know what you are talking about. Try again."
    end 
    response = storeSessionAttributeForStarship(@input, starship, true, false)
    JSON.generate(response)
  # check that the session attribute is there and that slots does not exist
  # this allows users to switch and ask for a different character

elsif (sessionAttribute == "starship") and 
      (intent == "manufacturer" or 
      intent == "length" or 
      intent == "class" or 
      intent == "cost" or 
      intent == "speed")
    
      puts "---SESSION ATTRIBUTE---"
      puts @request_payload['session']['attributes']['starship']
      puts "You have a starship"

      starship = @request_payload['session']['attributes']['starship']
      puts starship
      if (!starship)
        result = "You asked for something that is not applicable to what you want to know."
        response = startSessionAttribute(result, true, true)
        JSON.generate(response)
      else 
        puts intent
        intent = @request_payload['request']['intent']['name']
        puts intent
        result = getStarshipInformation(intent, starship)
        puts "---RESULT---"
        puts result
        response = storeSessionAttributeForStarship(starship, result, false, false)
        JSON.generate(response)
      end 
      
  elsif defined?(@request_payload['session']['attributes']['planet']) and 
        (intent == "orbital_period" or 
        intent == "climate" or 
        intent == "terrain" or 
        intent == "population" or 
        intent == "residents")

    puts "---SESSION ATTRIBUTE---"
    puts "You have a planet"
    # get name of character
    planet = @request_payload['session']['attributes']['planet']
    puts planet

    if (!planet)
      result = "You asked for something that is not applicable to what you want to know."
      response = startSessionAttribute(result, true, true)
      JSON.generate(response)
    else
      intent = @request_payload['request']['intent']['name']
      puts intent

      result = getPlanetInformation(intent, planet)
      puts "---RESULT---"
      puts result
  
      response = storeSessionAttributeForPlanet(planet, result, false, false)
      JSON.generate(response)
    end 
  elsif defined?(@request_payload['session']['attributes']['input']) and 
        (intent == "height" or 
        intent == "hair_color" or 
        intent == "home_world" or 
        intent == "character_films" or
        intent == "skin_color" or 
        intent == "birth_year" or 
        intent == "species" or 
        intent == "eye_color")
    puts "---SESSION ATTRIBUTE---"

    puts "You have a character"
    # get name of character
    name = @request_payload['session']['attributes']['input']
    puts name

    if (!name)
      result = "You asked for something that is not applicable to what you want to know."
      response = startSessionAttribute(result, true, true)
      JSON.generate(response)
    else 
      intent = @request_payload['request']['intent']['name']
      puts intent

      result = getCharacterInformation(intent, name)
      puts "---RESULT---"
      puts result
  
      response = storeSessionAttribute(name, result, false, false)
      JSON.generate(response)
    end 
  else
    response = storeSessionAttribute("Not Found", "Sorry, I cannot find anything. Try again.", false, false)
    JSON.generate(response)
  end 
end 


# Demo routes for testing purposes

# test route for query for a Star Wars character
get '/query-star-wars-character' do
  name = "Arm"
  character = queryStarWarsForCharacters(name)
  puts character
end


# test route for query for a Star Wars 
get '/query-all-characters' do
  name = "Luke Skywalker"
  characters = getAllCharacters()
  puts characters
end


# test route for query of one specific attribute
get '/query-for-field' do
  name = "Luke Skywalker"
  #characters = getAllCharacters()
  characters = getAllCharacters()
  character = getCharacterInfoField(characters, name, 'hair_color')
end

# test route for query of one specific character description
get '/query-for-string' do
  name = "Luke Skywalker"
  characters = getAllCharacters()
  character = getCharacterInfoString(characters, name)
end

# test route for getting the film crawl for a character
get '/get-films' do
  title = 'Return of the Jedi'
  films = getFilms()
  getFilmCrawl(films, title)

end

# test route for movies that have lower case characters in them 
get '/get-formatted-films' do 
    filmOrCharacterTest = 'a New hope'.downcase!
    if filmOrCharacterTest == 'the force awakens' or filmOrCharacterTest == 'a new hope'
      puts filmOrCharacterTest
      puts "Capitalizing "
      formattedFilm = filmOrCharacterTest.split.map(&:capitalize).*' '
      puts formattedFilm
      films = getFilms()
      result = getFilmCrawl(films, formattedFilm)
      puts "---FILMS---"
      puts result
    end

end 

get '/get-all-species' do
  species = getSpecies()
  getSpecie(species, 'Zabrak')
  #puts species
end 

get '/isMovie' do
  movie = isMovie("return of the jedi")
  puts movie 
end 

get '/get-all-planets' do
  #name = 'Corellia'
  #planets = getPlanets()
  #planet = getPlanet(planets, name)
  #puts planet
  planets = getPlanets()
  puts planets
end

get '/get-json-for-planet' do
  #puts returnJSON("hello world", true)
  
  puts storeSessionAttributeForPlanet("Luke Skywalker", "Planet", true, false)
end

get '/get-home-world' do
  characters = getAllCharacters()
  homeWorld = getCharacterHomeWorld("Luke Skywalker")
  #puts characters
end 

get '/get-character-films' do
  characters = getAllCharacters()
  films = getCharacterFilms(characters, "Luke Skywalker")
end

get '/get-character-skin-color' do
  characters = getAllCharacters()
  skin_color = getCharacterSkinColor("Luke Skywalker")
end  


########### Marvel API Code ############
# Note that this version will not work for Alex #
get '/api-key-hash' do 
  name = 'thor'
  puts name

  response = queryAPI(name)
  puts response

end 


get '/query-api' do
  name = 'thor'
  getDescription(name)
end

get '/get-planet-info' do
  orbitalPeriod = getPlanetOrbitalPeriod("Tatooine")
  puts orbitalPeriod
end 

get '/get-planet-residents' do
  residents = getPlanetResidents("Tatooine")
  puts residents
end 

get '/get-starships' do
  puts getStarships()
  #starship = getStarship("Sentinel-class landing craft")
  #puts starship
end 

get '/start-session' do 
  puts startSessionAttribute("Test", true, true)
end 

def getDescription(name)
  response = queryAPI(name)
  #puts response
  #puts api_res
  puts "---Results---"

  #puts response['data']['results']
  #puts response['data']['results'][0]

  return response['data']['results'][0]['description']

end

 
def getCharacterInformation(intent, name)
  if intent == "height"
    return getCharacterHeight(name)
  elsif intent == "hair_color"
    return getCharacterHairColor(name)
  elsif intent == "home_world"
    return getCharacterHomeWorld(name)
  elsif intent == "character_films"
    return getCharacterFilms(name)
  elsif intent == "skin_color"
    return getCharacterSkinColor(name)
  elsif intent == "birth_year"
    return getCharacterBirthYear(name)
  elsif intent == "eye_color"
    return getCharacterEyeColor(name)
  elsif intent == "species"
    return getCharacterSpecies(name)
  else
    return "I didn't catch that. Please try again. What do you want to know?"
  end
end 

def getPlanetInformation(intent, name)
  if intent == "orbital_period"
    return getPlanetOrbitalPeriod(name)
  elsif intent == "climate"
    return getPlanetClimate(name)
  elsif intent == "terrain"
    return getPlanetTerrain(name)
  elsif intent == "population"
    return getPlanetPopulation(name)
  elsif intent == "residents"
    return getPlanetResidents(name)
  else
    return "I didn't catch that. Please try again. What do you want to know?"
  end
end 

def getStarshipInformation(intent, name)
  if intent == "manufacturer"
    return getStarshipManufacturer(name)
  elsif intent == "length"
    return getStarshipLength(name)
  elsif intent == "class"
    return getStarshipClass(name)
  elsif intent == "cost"
    return getStarshipCost(name)
  elsif intent == "speed"
    return getStarshipSpeed(name)
  else
    return "I didn't catch that. Please try again. What do you want to know?"
  end
end 
