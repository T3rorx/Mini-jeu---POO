require 'bundler'
require 'pry'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'

player1 = Player.new("John")
player2 = Player.new("Jane")
DELAY = 1
n = 1 

puts "-------------------------------------------------"
puts "|    Bienvenue sur 'ILS VEULENT TOUS MA POO' !  |"
puts "|Le but du jeu est d'être le dernier survivant !|"
puts "-------------------------------------------------"
puts ""
puts "---- Username ----"
humanplayer = HumanPlayer.new(gets.chomp)

#binding.pry

while humanplayer.hp >= 0 && (player1.hp > 0 || player2.hp >0)
  puts
  puts
  puts
  puts "##############################"
  puts "######## R O U N D  #{n} ########"
  puts "##############################"
  humanplayer.show_state
  player1.show_state
  player2.show_state
  puts
  puts "Quelle action veux-tu effectuer ?"
  puts "a - Search a better Sword"
  puts "s - Search a Healt Pack"
  puts "Witch player Attack ?"
  puts "0 - #{player1.name} has #{player1.hp} HP"
  puts "1 - #{player2.name} has #{player2.hp} HP"
  puts "e - Exit the game"
  choice = gets.chomp
  if choice == "a" ; humanplayer.search_weapon
    elsif choice == "s" ; humanplayer.search_health_pack
    elsif choice == "0" ; humanplayer.attacks(player1)
    elsif choice == "1" ; humanplayer.attacks(player2)
  end
  break if choice == "e" || humanplayer.hp <= 0 || (player1.hp <= 0 && player2.hp <= 0)
  player1.attacks(humanplayer)
  break if humanplayer.hp <= 0 
  player2.attacks(humanplayer)
  break if humanplayer.hp <= 0 
  n = n + 1 
end
if humanplayer.hp > 0
# WIN
puts "################ CONGRATULATIONS ################"
puts "##################### YOU WIN ###################"
else
# LOSE

puts "##################### GAME OVER #################"
puts "##################### YOU LOSE ##################"
end

