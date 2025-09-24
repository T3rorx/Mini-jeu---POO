class Game
  attr_accessor :human_player
  attr_accessor :enemies_in_sight
  attr_accessor :players_left
  attr_accessor :round

  def initialize(human_name)
    @human_player = HumanPlayer.new(human_name)
    @players_left = 10
    @enemies_in_sight = []
    @round = 0
  end

  def kill_player(player)
    @enemies_in_sight.delete(player)
  end

  def is_still_ongoing?
    @human_player.alive? && (@players_left > 0 || !@enemies_in_sight.empty?)
  end

  def show_players
    Ui.section('STATUS')
    @human_player.show_state
    total_bots_remaining = @players_left + @enemies_in_sight.size
    puts "Enemies remaining (total): #{total_bots_remaining}"
    Ui.section('')
  end

  def menu
    puts "| What do you want to do?"
    puts "|  a - search for a better weapon"
    puts "|  s - search for a health pack"
    puts "|  Attack a visible enemy:"
    @enemies_in_sight.each_with_index do |enemy, idx|
      next unless enemy.alive?
      print "|   #{idx} - "
      enemy.show_state
    end
    Ui.section('')
  end

  def menu_choice(choice)
    case choice
    when 'a'
      @human_player.search_weapon
    when 's'
      @human_player.search_health_pack
    else
      if choice.match?(/^\d+$/)
        index = choice.to_i
        target = @enemies_in_sight[index]
        if target && target.alive?
          @human_player.attacks(target)
          kill_player(target) unless target.alive?
        else
          puts "Invalid choice."
        end
      else
        puts "Unknown command."
      end
    end
  end

  def enemies_attack
    @enemies_in_sight.each do |enemy|
      next unless enemy.alive?
      enemy.attacks(@human_player)
    end
  end

  def new_players_in_sight
    already_in_view = @enemies_in_sight.size
    if already_in_view >= @players_left
      puts "All players are already in sight"
      return
    end

    roll = rand(1..6)
    to_add = case roll
             when 1 then 0
             when 2..4 then 1
             else 2
             end

    max_possible = @players_left - already_in_view
    to_add = [to_add, max_possible].min

    if to_add.zero?
      puts "No new enemy appears."
      return
    end

    to_add.times do
      name = "joueur_#{rand(1000..9999)}"
      @enemies_in_sight << Player.new(name, 10)
      puts "A new enemy appears in sight: #{name}"
    end
  end

  def end
    Ui.section('GAME OVER')
    if @human_player.alive?
      puts Ui.color("| CONGRATS! YOU WON!", Ui::GREEN)
    else
      puts Ui.color("| You lost this time...", Ui::RED)
    end
    Ui.separator
  end
end


