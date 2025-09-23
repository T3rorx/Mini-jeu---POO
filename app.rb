require 'bundler'
require 'pry'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'

player1 = Player.new("José")
player2 = Player.new("Joe")
player3 = Player.new("Jaques")
player4 = Player.new("John")
player5 = Player.new("Jane",25)
player6 = Player.new("Julio",0)

puts "on my LEFT #{player1.name}" ; sleep 2
puts "on my LEFT #{player2.name}" ; sleep 2
#binding.pry

while player1.hp > 0 && player2.hp > 0
  player1.attacks(player2); sleep 1
  break if player2.hp <= 0
  player2.attacks(player1); sleep 1
  sleep 2  # fin de round
end

