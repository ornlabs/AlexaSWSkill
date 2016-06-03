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


def storeSessionAttribute(input, result, newSession, endSession)
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
    "session": {
      "new": "' + to_sb(newSession) + '"
    },
    "sessionAttributes": {
      "film": "' + input + '"
    },
    "response": {
      "outputSpeech": {
        "type": "PlainText",
        "text": " result "
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