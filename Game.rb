require_relative 'Heros'
require_relative 'Map'

class Game < Gosu::Window
  @@WIDTH, @@HEIGHT = 765, 627

  # Dimensions map : 24x14

  def initialize
    @nom = "GameJam"

    # Création de la map et du héros
    @map = Map.new
    @heros = Heros.new @map, 1, 10

    # Fond d'écran
    @bg = Gosu::Image.new("resources/bg.jpg")

    super @@WIDTH, @@HEIGHT, options = {:fullscreen => false}
    caption = @NOM

    self.show
  end

  def draw
    @bg.draw 0,0,0
    @map.draw
    @heros.draw
  end

  def update
    # Déplacements du personnage 
    @heros.setDirection(Direction::LEFT) if Gosu::button_down?(Gosu::KbLeft)
    @heros.setDirection(Direction::RIGHT) if Gosu::button_down?(Gosu::KbRight)
    @heros.jump if Gosu::button_down?(Gosu::KbUp)

    # Tirs
    @heros.shoot if Gosu::button_down?(Gosu::KbX)
    # Changer d'arme : pour tester
    @heros.switchWeapon if Gosu::button_down?(Gosu::KbS)

    # Mise à jour des déplacements
    @heros.move

    close if Gosu::button_down?(Gosu::KbEscape)
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

