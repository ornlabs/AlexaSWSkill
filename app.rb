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
#use Rack::Env, envfile: 'config/local_env.yml'

post '/' do
  request.body.rewind
  @request_payload = JSON.parse request.body.read

  puts "---REQUEST PAYLOAD---"
  puts @request_payload

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
  elsif @request_payload['request']['intent']['name'] == 'AMAZON.CancelIntent'

    
    response = returnJSON("Goodbye. See you later...", true)
    JSON.generate(response)

  elsif @request_payload['request']['intent']['name'] == 'movie'
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
  elsif @request_payload['request']['intent']['name'] == 'character'

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
  elsif @request_payload['request']['intent']['name'] == 'planets'

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
  elsif defined?(@request_payload['session']['attributes']) 

    puts "---SESSION ATTRIBUTE---"
    #puts @request_payload['session']['attributes']
    #name = @request_payload['session']['attributes']['input']

    if defined?(@request_payload['session']['attributes']['input']) 
      puts "You have a character"
      name = @request_payload['session']['attributes']['input']
      intent = @request_payload['request']['intent']['name']
      puts intent
      result = getCharacterInformation(intent, name)

      puts "---RESULT---"
      puts result
    
      response = storeSessionAttribute(name, result, false, false)
      JSON.generate(response)
    else 
      puts "You have a planet"
      # get the intent 
      planet = @request_payload['session']['attributes']['planet']
      puts planet
      intent = @request_payload['request']['intent']['name']
      puts intent
      result = getPlanetInformation(intent, planet)

      planetuts "---RESULT---"
      puts result
    
      response = storeSessionAttributeForPlanet(planet, result, false, false)
      JSON.generate(response)
    end 
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
  else
    return "I didn't catch that. Please try again. What do you want to know?"
  end
end 
