require 'rest-client'
require 'json'
require 'pry'

# iterate over the character hash to find the collection of `films` for the given
#   `character`
# collect those film API urls, make a web request to each URL to get the info
#  for that film
# return value of this method should be collection of info about each film.
#  i.e. an array of hashes in which each hash reps a given film
# this collection will be the argument given to `parse_character_movies`
#  and that method will do some nice presentation stuff: puts out a list
#  of movies by title. play around with puts out other info about a given film.

def titleize_name(character)
  names_array = character.split(" ")
  names_array.collect { |name| name[0] = name[0].upcase}
  capital_name = names_array.join(" ")
  if capital_name.include?("-")
    capital_name.gsub(/-[a-z]/) {|letter| letter.upcase}
  else
    capital_name
  end
  # binding.pry
end

def make_request(link = "http://www.swapi.co/api/people/")
  all_characters = RestClient.get(link)
  character_hash = JSON.parse(all_characters)
end

# 1. To check each character hash to see if the character
# is there before going to the next page
# 2. To create an array of character hashes from all the pages
# and iterate through that

def get_character_movies_from_api(character)
  film_array = []
  titleized_character = titleize_name(character)
  character_hash = make_request
  while film_array == []
    character_hash["results"].each do |person|
      if person["name"] == titleized_character
          film_array = person["films"].collect {|film| make_request(film)}
      end
    end
    character_hash = make_request(character_hash["next"]) if character_hash["next"] != nil
  end
  film_array
  # binding.pry
end

def parse_character_movies(films_hash)
  films_hash.each_with_index do |film, index|
    puts "#{index + 1}. #{film["title"]}"
  end
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
