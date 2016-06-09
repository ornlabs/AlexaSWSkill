# Jedi Archives

## What I did

To create a new skill for Alexa, we first created a schema on the Amazon Web Developer Portal. 

This schema forms the model, or basis for what users can ask or say to Alexa. 

For the Star Wars characters, we want users to be able to ask about the character's height, hair color, home world and each of these qualities are referred to as intents. After defining these intents, we can define references to these intents which is called a slot. Since we want to ask about Star Wars characters, we can add a slot for the list of characters which may include Luke Skywalker, Darth Vader, Leia Organa, and etc. 

Finally, to allow users to complete this model, we add a list of sample utterances or what users can say to Alexa to interact with her. For example, some samples include:

- get information for {person}
- tell me about {person}
- character who is {person}

After defining this model we must define a web service for Alexa to interact with as people interact with her. 

This web service is essential becuase Alexa interacts with it to generate a response for the user. 

## The Web Service

The web service is made up of two parts. First, it consists of a request which is what Alexa is sending to the service. When Alexa sends this request (POST), Alexa gets back a response for to return to the user. 

This is where all of our work as developers come in. 

As developers, we can specify what Alexa does when she sends this POST request. 

Here, I am connecting this part to the Star Wars API to generate a query to the API to get information about the specific character the user is asking for. For example, the user may be asking for Luke Skywalker. 

- tell me about Luke Skywalker

When Alexa sends this request, I store the name "Luke Skywalker" in a session attribute. This is important because it allows future requests to be about that particular character. 

Now, when the character asks for the user's height, that character is stored in the session and we can query the height of that particular character. 


