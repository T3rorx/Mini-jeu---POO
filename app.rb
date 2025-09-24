require 'bundler'
require 'pry'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'

player1 = Player.new("José")
player2 = Player.new("John")
player3 = Player.new("Jaques")
player4 = Player.new("Joe")
player5 = Player.new("Jane",25)
player6 = Player.new("Julio",0)
DELAY = 1
time = 1

puts "on my LEFT #{player1.name}" ; sleep time
puts "on my LEFT #{player2.name}" ; sleep time
#binding.pry

n = 1 
while player1.hp > 0 && player2.hp > 0
  puts
  puts
  puts "##### ROUND#{n} #####"
  player1.show_state
  player2.show_state
  puts "##### FIGHT ######"
  player1.attacks(player2)
  break if player2.hp <= 0
  player2.attacks(player1)
  break if player1.hp <= 0
  n = n + 1 
end

if player1.hp <= 0 ; winner = player2
else winner = player1
end
puts
puts
puts "#####################"
puts "###### Result #######"
puts "##### The winner ####"
puts "######## IS  ########"
puts "####### #{winner.name} ########"
puts "## CONGRATULATIONS ##"
puts "#####################"