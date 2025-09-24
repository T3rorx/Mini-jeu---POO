class Player
  # Base bot player
  attr_accessor :name
  attr_accessor :hp

  @@all_player = []

  def initialize(name, hp = 10)
    @name = name
    @hp = hp
    @@all_player << self
  end

  def self.all
    @@all_player
  end

  # Compatibility accessors with spec wording
  def life_points
    @hp
  end

  def life_points=(value)
    @hp = value
  end

  def alive?
    @hp > 0
  end

  def show_state
    if @hp <= 0
      puts Ui.color("#{@name} has 0 HP", Ui::RED)
    else
      puts "#{@name} has #{@hp} HP"
    end
  end

  def gets_damage(amount)
    @hp -= amount
    @hp = 0 if @hp.negative?
    puts Ui.color("Player #{@name} has been killed!", Ui::RED) if @hp <= 0
  end

  def attacks(other_player)
    return unless alive?
    puts Ui.color("#{@name} attacks #{other_player.name}", Ui::YELLOW)
    damage = compute_damage
    other_player.gets_damage(damage)
    puts Ui.color("It deals #{damage} damage", Ui::BLUE)
  end

  def compute_damage
    rand(1..6)
  end
end

class HumanPlayer < Player
  attr_accessor :weapon_level

  def initialize(name)
    super(name, 100)
    @weapon_level = 1
  end

  def show_state
    puts Ui.color("#{@name} has #{@hp} HP and a level #{@weapon_level} weapon", Ui::CYAN)
  end

  def compute_damage
    rand(1..6) * @weapon_level
  end

  def search_weapon
    level_found = rand(1..6)
    puts Ui.color("You found a level #{level_found} weapon", Ui::YELLOW)
    if level_found > @weapon_level
      @weapon_level = level_found
      puts Ui.color("Nice! It's better than your current weapon: you equip it.", Ui::GREEN)
    else
      puts Ui.color("Meh... It's not better than your current weapon.", Ui::BLUE)
    end
  end

  def search_health_pack
    roll = rand(1..6)
    case roll
    when 1
      puts Ui.color("You found nothing...", Ui::BLUE)
    when 2..5
      gained = 50
      @hp = [@hp + gained, 100].min
      puts Ui.color("+50 HP pack found!", Ui::GREEN)
    when 6
      gained = 80
      @hp = [@hp + gained, 100].min
      puts Ui.color("Jackpot! +80 HP pack found!", Ui::GREEN)
    end
  end
end
