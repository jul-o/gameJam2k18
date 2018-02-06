require_relative 'Heros'
require_relative 'Map'
require_relative 'Mechant'

class Game < Gosu::Window
  @@WIDTH, @@HEIGHT = 765, 627

  # Dimensions map : 24x14

  def initialize
    @nom = "GameJam"
    @bg = Gosu::Image.new("resources/bgcases_dup.png")

    # Création de la map et du héros
    @map = Map.new
    @heros = Heros.new @map, 5, 0
    @mechant = Mechant.new(@map, 0, 0)

    super @@WIDTH, @@HEIGHT, options = {:fullscreen => false}
    caption = @NOM

    self.show
  end

  def draw
    fx = @@WIDTH.to_f/@bg.width.to_f
    fy = @@HEIGHT.to_f/@bg.height.to_f
    @bg.draw(0, 0, 0, fx, fy)
    @heros.draw
    @mechant.draw
  end

  def update
    # Déplacement du personnage 
    @heros.setDirection(Direction::LEFT) if Gosu::button_down?(Gosu::KbLeft)
    @heros.setDirection(Direction::RIGHT) if Gosu::button_down?(Gosu::KbRight)
    @heros.jump if Gosu::button_down?(Gosu::KbUp)

    # Mise à jour des déplacements
    @heros.move
    @mechant.move

    # On regarde si le héros est touché par un mechant
    puts "AHAH PERDU MISKINE FDP" if (perdu?)

    close if Gosu::button_down?(Gosu::KbEscape)
  end

  #
  #
  # /!\ CONSIDERE L'ENNEMI COMME UNIQUE, PAS ENCORE GERE COMME COLLECTION héhé
  #
  #
  # Vérifie si le héros est touché par un monstre ou non
  # ==> Vrai si en contact
  def perdu?
    # Coordonnées de l'ennemi en pixels
    mX = @mechant.x
    mY = @mechant.y

    # Coordonnées du personnage
    x = @heros.x
    y = @heros.y

    rect1 = [x, y, Heros.SIZE[0], Heros.SIZE[1]]
    rect2 = [mX, mY, @mechant.sizeX, @mechant.sizeY]

    return ((rect1[0] < rect2[0] + rect2[2] && rect1[0] + rect1[2] > rect2[0]) &&
        (rect1[1] < rect2[1] + rect2[3] && rect1[3] + rect1[1] > rect2[1]))
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

