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
    if @hp <= 0 ; puts "#{@name} is DEAD!"
    elsif @hp <= 25 ; puts "Low health: #{@name} has #{@hp} HP"
    elsif @hp < 100 ; puts "#{@name} has #{@hp} HP" 
    elsif @hp == 100 ; puts "#{@name} is MAX Health" 
    end
  end

  def gets_damage
    dmg = compute_damage
    if @hp < dmg
      dmg = @hp
    else
    end
    puts "#{@name} take #{dmg} DMG"
    @hp = @hp - dmg 
    if @hp <= 0
      puts "#{@name} was KILLED"
      show_state
    else
      show_state
    end
  end
  
  def attacks(player)
    puts "### #{@name} Attack #{player.name}" 
    player.gets_damage
  end

  def compute_damage
    return rand(1..20)
  end

end

