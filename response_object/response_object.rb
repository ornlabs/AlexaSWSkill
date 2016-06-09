class ResponseObject
  def initialize()
  end


end


def returnJSON(text, option)
    json = JSON.parse(
    '{
  
    "version": "1.0",
    "response": {
      "outputSpeech": {
        "type": "PlainText",
        "text": "' + text + '"
       },
      "shouldEndSession": " ' + to_sb(option) + ' "
      }
    }')
end 


def returnIntroduction()
    json = JSON.parse(
    '{
      "version": "1.0",
      "response": {
        "outputSpeech": {
          "type": "PlainText",
          "text": "Welcome to Jedi Archives. What would you like to know?"
        },
        "shouldEndSession": false
      }
    }')
end 


def storeSessionAttribute(input, result, newSession, endSession)
  puts "---RESULT---"
  puts result
  json = JSON.parse(
  '{

    "version": "1.0",
    "session": {
      "new": "' + to_sb(newSession) + '"
    },
    "sessionAttributes": {
      "input": "' + input + '"
    },
    "response": {
      "outputSpeech": {
        "type": "PlainText",
        "text": "' + result + '"
       },
      "shouldEndSession": "' + to_sb(endSession) + '"
    }
  }')
end


def storeSessionAttributeForMovie(input, result, newSession, endSession)
   json = JSON.parse(
  '{

    "version": "1.0",
    "sessionAttributes": {
      "film": "' + input + '"
    },
    "response": {
      "outputSpeech": {
        "type": "PlainText",
        "text": "' + result + '"
       },
      "shouldEndSession": "false"
    }
  }')
end

def storeSessionAttributeForPlanet(planet, result, newSession, endSession)
   json = JSON.parse(
  '{

    "version": "1.0",
    "sessionAttributes": {
      "planet": "' + planet + '"
    },
    "response": {
      "outputSpeech": {
        "type": "PlainText",
        "text": "' + result + '"
       },
      "shouldEndSession": "false"
    }
  }')
end


def storeSessionAttributeForStarship(starship, result, newSession, endSession)
  json = JSON.parse(
  '{

    "version": "1.0",
    "sessionAttributes": {
      "starship": "' + starship + '"
    },
    "response": {
      "outputSpeech": {
        "type": "PlainText",
        "text": "' + result + '"
       },
      "shouldEndSession": "false"
    }
  }')
end    

def startSessionAttribute(result, newSession, endSession)
  puts "---RESULT---"
  puts result
  json = JSON.parse(
  '{

    "version": "1.0",
    "session": {
      "new": "' + to_sb(newSession) + '"
    },
    "response": {
      "outputSpeech": {
        "type": "PlainText",
        "text": "' + result + '"
       },
      "shouldEndSession": "' + to_sb(endSession) + '"
    }
  }')
end 

def to_sb(option)
  if option == true
    return 'true'
  else
    return 'false'
  end 
end 