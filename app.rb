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

    response = storeSessionAttribute(@input, "You wanted to know about a planet.", true, false)
    JSON.generate(response)
  # check that the session attribute is there and that slots does not exist
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

get '/get-json-for-crawler' do
  #puts returnJSON("hello world", true)
  puts "JSON"
  url = 'http://swapi.co/api/films/1'
  puts url 
  data = HTTParty.get(url)['opening_crawl']
  puts data

  films = 
  {
    "A New Hope" => "It is a period of civil war. Rebel spaceships, striking from a hidden base, have won their first victory against the evil Galactic Empire.During the battle, Rebel spies managed to steal secretplans to the Empire's ultimate weapon, the DEATH STAR, an armored space station with enough power to destroy an entire planet. Pursued by the Empire's sinister agents, Princess Leia races home aboard her starship, custodian of the stolen plans that can save her people and restore freedom to the galaxy....",
    "The Empire Strikes Back" => "It is a dark time for the Rebellion. Although the Death Star has been destroyed, Imperial troops have driven the Rebel forces from their hidden base and pursued them across the galaxy. Evading the dreaded Imperial Starfleet, a group of freedom fighters led by Luke Skywalker has established a new secret base on the remote ice world of Hoth. The evil lord Darth Vader, obsessed with finding young Skywalker, has dispatched thousands of remote probes into the far reaches of space....",
    "Return of the Jedi" => "Luke Skywalker has returned to his home planet of Tatooine in an attempt to rescue his friend Han Solo from the clutches of the vile gangster Jabba the Hutt. Little does Luke know that the GALACTIC EMPIRE has secretly begun construction on a new armored space station even more powerful than the first dreaded Death Star. When completed, this ultimate weapon will spell certain doom for the small band of rebelsstruggling to restore freedom to the galaxy...", 
    "The Phantom Menace" => "Turmoil has engulfed the Galactic Republic. The taxation of trade routes to outlying star systems is in dispute. Hoping to resolve the matter with a blockade of deadly battleships, the greedy Trade Federation has stopped all shipping to the small planet of Naboo. While the Congress of the Republic endlessly debates this alarming chain of events, the Supreme Chancellor has secretly dispatched two Jedi Knights, the guardians of peace and justice in the galaxy, to settle the conflict....", 
    "Attack of the Clones" => "There is unrest in the Galactic Senate. Several thousand solar systems have declared their intentions to leave the Republic. This separatist movement, under the leadership of the mysterious Count Dooku, has made it difficult for the limited number of Jedi Knights to maintain peace and order in the galaxy. Senator Amidala, the former Queen of Naboo, is returning to the Galactic Senate to vote on the critical issue of creating an ARMY OF THE REPUBLIC to assist the overwhelmed Jedi....", 
    "Revenge of the Sith" => "War! The Republic is crumbling under attacks by the ruthless Sith Lord, Count Dooku. There are heroes on both sides. Evil is everywhere. In a stunning move, the fiendish droid leader, General Grievous, has swept into the Republic capital and kidnapped Chancellor Palpatine, leader of the Galactic Senate. As the Separatist Droid Army attempts to flee the besieged capital with their valuable hostage, two Jedi Knights lead a desperate mission to rescue the captive Chancellor....", 
    "The Force Awakens" => "Luke Skywalker has vanished. In his absence, the sinister FIRST ORDER has risen from the ashes of the Empire and will not rest until Skywalker, the last Jedi, has been destroyed. With the support of the REPUBLIC, General Leia Organa leads a brave RESISTANCE. She is desperate to find her brother Luke and gain his help in restoring peace and justice to the galaxy. Leia has sent her most daringpilot on a secret mission to Jakku, where an old ally has discovered a clue to Luke's whereabouts...."
  }
  puts films
  puts films["A New Hope"]
  puts storeSessionAttributeForMovie("Luke Skywalker", films["A New Hope"], true, false)
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
