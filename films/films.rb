
class Films
  def initialize()
  end


end


def getFilms()
  url = 'http://swapi.co/api/films/'
  puts url 
  data = HTTParty.get(url)['results']
  return data
end 

def getFilmCrawl(films, title)
  puts title
  films.each do |film|
    #puts character['name']
    if title == film['title']
      return film['opening_crawl']
    end 
  end 
  return "Sorry. I cannot find that film."
end



def isMovie(title)
  titleLowercase = title.downcase
  if titleLowercase == 'the force awakens' or titleLowercase == 'a new hope' or titleLowercase == 'the empire strikes back' or titleLowercase == 'attack of the clones' or titleLowercase== 'the phantom menace' or titleLowercase == 'revenge of the sith' or titleLowercase == 'return of the jedi' 
    if titleLowercase == 'attack of the clones'
        return 'Attack of the Clones'
    elsif titleLowercase == 'revenge of the sith'
        return 'Revenge of the Sith' 
    elsif titleLowercase == 'return of the jedi'
        return 'Return of the Jedi'
    else
        puts "Capitalizing "
        formattedFilm = title.split.map(&:capitalize).*' '
        puts formattedFilm
        return formattedFilm
    end
  else 
    return "Sorry. I cannot find that film."
  end 
end 

def getOpeningCrawl(film)
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
  return films[film]

end