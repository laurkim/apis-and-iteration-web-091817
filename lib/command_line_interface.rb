require_relative "api_communicator"

def welcome
  puts "Welcome to the Star Wars Character Program"
end

def get_character_from_user
  puts "please enter a character"
  character = gets.chomp.downcase
end
