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
       "session": {
         "new": "true"
      },
      "response": {
        "outputSpeech": {
          "type": "PlainText",
          "text": "Welcome to Star Archives. What would you like to know?"
        },
      "reprompt": {
          "outputSpeech": {
          "type": "PlainText",
          "text": "Would you like to know anything else?"
        }
      }, 
      "shouldEndSession": "false"
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
        "card": {
        "type": "Simple",
        "title": "Star Wars Character",
        "content": "' + result + '"
      },
      "reprompt": {
          "outputSpeech": {
          "type": "PlainText",
          "text": "Would you like to know anything else?"
        }
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
        "card": {
        "type": "Simple",
        "title": "Star Wars Movie",
        "content": "' + result + '"
      },
      "reprompt": {
          "outputSpeech": {
          "type": "PlainText",
          "text": "Would you like to know anything else?"
        }
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
        "card": {
        "type": "Simple",
        "title": "Star Wars Planet",
        "content": "' + result + '"
      }, 
      "reprompt": {
          "outputSpeech": {
          "type": "PlainText",
          "text": "Would you like to know anything else?"
        }
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
        "card": {
        "type": "Simple",
        "title": "Star Wars Starship",
        "content": "' + result + '"
      }, 
      "reprompt": {
          "outputSpeech": {
          "type": "PlainText",
          "text": "Would you like to know anything else?"
        }
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


def returnError()
  json = JSON.parse(
  '{
    "version": "1.0",
    "response": {
      "outputSpeech": {
        "type": "PlainText",
        "text": "You asked for something that I cannot find. Try again. "
      },
      "shouldEndSession": "false"
    }
  }')
end


def returnHelp()
    json = JSON.parse(
    '{
      "version": "1.0",
      "response": {
        "outputSpeech": {
          "type": "PlainText",
          "text": "This is your treasure trove of Star Wars knowledge. You can ask about characters, planets, starships, and films. For example, you can say: Tell me about LukeSkywalker. Then follow up with, How tall is he? What is his eye color? What films was he in? And so much more. What would you like to know?"
        },
      "reprompt": {
          "outputSpeech": {
          "type": "PlainText",
          "text": "Anything else you want to know?"
        }
      }, 
      "shouldEndSession": "false"
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