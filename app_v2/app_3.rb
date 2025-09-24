require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'
require_relative 'lib/ui'

Ui.clear_screen
Ui.box(title: "Welcome to 'THEY ALL WANT MY OOP'!", lines: ["Be the last one standing!"])

print "What's your hero name? > "
user_name = STDIN.gets&.chomp
user_name = 'Wolverine' if user_name.nil? || user_name.strip.empty?

my_game = Game.new(user_name)

while my_game.is_still_ongoing?
  my_game.round += 1
  Ui.clear_screen
  Ui.banner(Ui.color("ROUND #{my_game.round}", Ui::CYAN))
  sleep 0.5
  my_game.show_players
  my_game.new_players_in_sight
  sleep 0.5
  Ui.section('MENU')
  my_game.menu
  print "> "
  choice = STDIN.gets&.chomp.to_s
  puts
  my_game.menu_choice(choice)
  sleep 0.5
  Ui.separator
  break unless my_game.is_still_ongoing?
  Ui.section('ENEMY PHASE')
  my_game.enemies_attack
  Ui.separator
  sleep 0.8
end

my_game.end


