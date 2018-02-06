require_relative 'Heros'
require_relative 'Map'
require_relative 'Spawn'
require_relative 'Caisse'

GRAVITY_Y = 9

class Game < Gosu::Window
  @@WIDTH, @@HEIGHT = 765, 627

  # Dimensions map : 24x14

  def initialize
    @nom = "GameJam"
    @bg = Gosu::Image.new("resources/bgcases_dup.png")

    # Création de la map et du héros
    @map = Map.new
    @heros = Heros.new @map, 0, 10
    @spawns = initSpawns()
    @caisse = Caisse.new 100, 50

    super @@WIDTH, @@HEIGHT, options = {:fullscreen => false}
    self.caption = @nom

    self.show
  end


  def draw
    fx = @@WIDTH.to_f/@bg.width.to_f
    fy = @@HEIGHT.to_f/@bg.height.to_f
    @bg.draw(0, 0, 0, fx, fy)
    @heros.draw
    @spawns.each do |spawn|           
        spawn.tick
    end
    @caisse.tick @map
  end

  def update
    # Déplacement du personnage 
    @heros.setDirection(Direction::LEFT) if Gosu::button_down?(Gosu::KbLeft)
    @heros.setDirection(Direction::RIGHT) if Gosu::button_down?(Gosu::KbRight)
    @heros.jump if Gosu::button_down?(Gosu::KbUp)

    # Mise à jour des déplacements
    @heros.move

    close if Gosu::button_down?(Gosu::KbEscape)

  end

  def initSpawns
    spawns = [Spawn.new(50,50,10)]
    return spawns
  end

  # Getters
  def self.WIDTH
    @@WIDTH
  end

  def self.HEIGHT
    @@HEIGHT
  end

  def self.CELLSIZE
    @@CELLSIZE
  end

  def getMap
    @map
  end
end

