require 'sinatra'
require 'json'
require 'net/http'
require 'httparty'
require 'digest/md5'
require 'rack/env'
#require './marvel/marvel'
require  './character/character'
require  './films/films'
require  './response_object/response_object'
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
  elsif defined?(@request_payload['session']['attributes']['input']) and 
    !defined?(@request_payload['request']['intent']['slots']['person']['value'])

    name = @request_payload['session']['attributes']['input']
    puts name
    puts "You saved an attribute"

    # get the intent 
    intent = @request_payload['request']['intent']['name']
    puts intent
    result = getCharacterInformation(intent, name)

    puts "---RESULT---"
    puts result
    
    response = storeSessionAttribute(name, result, false, false)
    JSON.generate(response)
  # check that the intent is for character
  elsif @request_payload['request']['intent']['name'] == 'character'

    puts "---NEW SESSION---"
    @input = @request_payload['request']['intent']['slots']['person']['value']
    puts @input

    #films = getFilms()
    #film = isMovie(@input)
    #formattedFilm = getFilmCrawl(films, film)

    character = getCharacterName(@input)     
    if character != "Sorry. I cannot find that character."
      result = character
    else
      result = "I don't know what you are talking about. Try again."
    end 

    response = storeSessionAttribute(@input, result, true, false)
    JSON.generate(response)
  elsif @request_payload['request']['intent']['name'] == 'movie'
    puts "---NEW SESSION---"
    @input = @request_payload['request']['intent']['slots']['film']['value']
    puts @input

    films = getFilms()
    film = isMovie(@input)

    puts "---Film---"
    puts film
    filmCrawl = getFilmCrawl(films, film)

    puts "---Film Crawl---"
    puts filmCrawl
    response = storeSessionAttributeForMovie(@input, filmCrawl, true, false)

    puts response
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
  name = 'Corellia'
  planets = getPlanets()
  planet = getPlanet(planets, name)
  puts planet
end

get '/get-json' do
  #puts returnJSON("hello world", true)
  puts storeSessionAttributeForMovie("Luke Skywalker", "Test", true, false)
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
