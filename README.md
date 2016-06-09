# AlexaSWSkill

Here's the link to Alexa skills: <http://alexa.amazon.com>

## Characters

Here's the steps of the interaction:

Say: 

```
Alexa, ask Comic Test, tell me about Luke Skywalker
```

Alexa will make the POST request and an API call to the Star Wars API. 

You can continue by asking about height, hair color, home world, films the character has been in, skin color, birth year, species, and eye color. 

```
How tall is he?
```

```
What films has he been in?
```

```
What is his home world?
```

## Movies

You can also ask Alexa about movies as well:

Say: 

```
Alexa, ask Comic Test, tell me about A New Hope
```

Alexa reads the opening crawl of the movie. 

## Planets

You can ask Alexa about different Star Wars planets:

```
Tell me about Tatooine
```

The endpoints included are orbital period, climate, terrain, population, and residents. 


```
What is the orbital period?
```

```
Who are the residents?
```

## Starships

You can ask about different Star Wars starships:

```
Tell me about Death Star
```

The endpoints included are manufacturer, length, class, cost, speed.

``` 
How fast can it go?
```

```
How much does it cost?
```



## Testing

###Working Characters:

1. Luke Skywalker
2. Darth Vader
3. Leia Organa
4. Owen Lars
5. Beru Whitesun lars
6. Biggs Darklighter 
7. Obi-wan Kenobi
8. Anakin Skywalker
9. Wilhuff Tarakin
10. Chewbacca
11. Han Solo
12. Greedo
13. Wedge Antilles
14. Jek Tono Porkins
15. Yoda
16. Palpatine
17. Boba Fett
18. Bossk
19. Lando Calrissian 
20. Lobot
...


###Working Planets

1. Hoth 
2. Dagobah
3. Bespin
4. Endor
5. Naboo
6. Kamino
7. Genosis
8. Utapau
9. Mustafar
10. Kashyyyk
11. Mygeeto
12. Felucia
13. Cato Neimoidia
14. Saleucami
15. Stewjon
16. Eriadu
17. Corellia
18. Rodia
19. Nal Hutta
20. Dantooine
...

### Starships

1. Sentinel class landing craft
2. Death Star
3. Millennium Falcon
4. Y Wing
5. X Wing
6. Executor
7. Imperial Shuttle 
8. Calamari Cruiser
9. Republic Cruiser
10. Naboo fighter
11. Naboo Royal Starship 
12. Jedi starfighter
13. Star Destroyer 
14. Rebel transport
15. Droid control ship
16. Republic Assault ship 
17. Solar Sailer
18. Republic attack cruiser
19. Naboo star skiff
20. Jedi Interceptor 
...

If request takes too long, crash.
Random crashes sometimes. 
If you interact with it for a long time, you get a exceeded_max_reprompts error.
If left too long, she times out. 

