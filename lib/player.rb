class Player
  attr_accessor :name, :hp
    @@all_player = []

  def initialize(name, hp = 100)
    @name = name
    @hp = hp
    @@all_player << self
  end

  def self.all
    @@all_player
  end

  def show_state
    if @hp <= 0 ; puts "#{@name} is DEAD!" ; sleep DELAY
    elsif @hp <= 25 ; puts "#{@name} has [#{@hp}HP] <<--------- [Low health]" ; sleep DELAY
    elsif @hp < 100 ; puts "#{@name} has [#{@hp}HP]" ; sleep DELAY
    elsif @hp == 100 ; puts "#{@name} is MAX Health" ; sleep DELAY
    end
  end

  def gets_damage(player)
    dmg = compute_damage
    if player.hp < dmg
      dmg = player.hp
    else
    end
    puts "#{@name} do #{dmg} DMG to #{player.name}" ; sleep DELAY
    player.hp = player.hp - dmg 
    if player.hp <= 0
      puts "#{player.name} was KILLED" ; sleep DELAY
      player.show_state
    else
      player.show_state
    end
  end
  
  def attacks(player)
    puts "#{@name} Attack #{player.name}" ; sleep DELAY
    gets_damage(player)
  end

  def compute_damage
    return rand(1..20)
  end

end

class HumanPlayer < Player
  attr_accessor :name, :hp, :weapon_level

    def initialize(name)
    @name = name
    @hp = 1000
    @weapon_level = 1
    @@all_player << self
  end

  def show_state
    if @hp <= 0 ; puts "#{@name} is DEAD!" ; sleep DELAY
    elsif @hp <= 250 ; puts "[Low health] #{@name} has [#{@hp}HP], Sword lvl #{@weapon_level}"; sleep DELAY
    elsif @hp < 1000 ; puts "#{@name} has #{@hp} HP, Sword lvl #{@weapon_level}"; sleep DELAY
    elsif @hp == 1000 ; puts "#{@name} is MAX Health, Sword lvl #{@weapon_level}"; sleep DELAY
    end
  end

  def compute_damage
  return rand(1..20) * @weapon_level
  end

  def search_weapon
    new_weapon = rand(1..6)
    puts "You find a Sword lvl #{new_weapon}"; sleep DELAY
    if new_weapon > @weapon_level
      @weapon_level = new_weapon
    else
      puts "LVL #{new_weapon} Fuck that Shit ..."; sleep DELAY
      puts "i already have a Sword LVL #{@weapon_level} "; sleep DELAY
    end
  end

  def search_health_pack
    health_pack_roll = rand(1..6)
    heal50 = 50
    heal80 = 80
    if health_pack_roll == 1 ; puts "NOTHING ..."; sleep DELAY
    elsif health_pack_roll.between?(2, 5)
      if @hp + heal50 > 1000 ; heal50 = 1000 - @hp ; end
      @hp = @hp + heal50 
      puts "You find a Heath pack [#{heal50}]"; sleep DELAY
    else 
      if @hp + heal80 > 1000 ; heal80 = 1000 - @hp ; end
      @hp = @hp + heal80 
      puts " You find a Big Health Pack [#{heal80}HP]"; sleep DELAY
    end
    if @hp > 1000 ; @hp = 1000 ; end
  end
end
