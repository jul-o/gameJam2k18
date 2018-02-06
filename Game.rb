require_relative 'Heros'
require_relative 'Map'
require_relative 'Mechant'
require_relative 'Spawn'

class Game < Gosu::Window
  @@FPS = 60
  @@REFRESH_RATE = 1000/@@FPS

  @@WIDTH, @@HEIGHT = 765, 627

  # Dimensions map : 24x14

  def initialize
    @nom = "GameJam"
    @bg = Gosu::Image.new("resources/bgcases_dup.png")

    # Création de la map et du héros
    @map = Map.new
    @heros = Heros.new @map, 5, 0
    @mechants = Array.new
    @spawns = initSpawns

    super @@WIDTH, @@HEIGHT, options = {:fullscreen => false, :update_interval => @@REFRESH_RATE}
    caption = @NOM

    self.show

    @perdu = false
  end

  def initSpawns
    [Spawn.new(2, 2, 20, @map)]
  end

  def draw

      fx = @@WIDTH.to_f/@bg.width.to_f
      fy = @@HEIGHT.to_f/@bg.height.to_f
      @bg.draw(0, 0, 0, fx, fy)
      @heros.draw
      if !@perdu
      @spawns.each {|s|
        resSpawn = s.tick
        if !(resSpawn === 1)
          @mechants.push resSpawn
        end
      }
      @mechants.each do |m|
        m.draw
      end
    end
  end

  def update
    if(!@perdu)
      # Déplacement du personnage
      @heros.setDirection(Direction::LEFT) if Gosu::button_down?(Gosu::KbLeft)
      @heros.setDirection(Direction::RIGHT) if Gosu::button_down?(Gosu::KbRight)
      @heros.jump if Gosu::button_down?(Gosu::KbUp)

      # Mise à jour des déplacements
      @heros.move
      @mechants.each {|m| m.move}

      # On regarde si le héros est touché par un mechant
      if (perdu?)
        puts "AHAH PERDU MISKINE FDP"
        @perdu = true
      end
    end

    close if Gosu::button_down?(Gosu::KbEscape)
  end

  #
  #
  #
  #
  # Vérifie si le héros est touché par un monstre ou non
  # ==> Vrai si en contact
  def perdu?
    # Coordonnées de l'ennemi en pixels

    touchai = false
    @mechants.each {|m|
      mX = m.x
      mY = m.y

      # Coordonnées du personnage
      x = @heros.x
      y = @heros.y

      rect1 = [x, y, Heros.SIZE[0], Heros.SIZE[1]]
      rect2 = [mX, mY, m.sizeX, m.sizeY]

      touchai = ((rect1[0] < rect2[0] + rect2[2] && rect1[0] + rect1[2] > rect2[0]) &&
          (rect1[1] < rect2[1] + rect2[3] && rect1[3] + rect1[1] > rect2[1]))
    }
    return touchai
  end

  # Getters
  def self.WIDTH
    @@WIDTH
  end

  def self.HEIGHT
    @@HEIGHT
  end

  def self.FPS
    @@FPS
  end

  def self.CELLSIZE
    @@CELLSIZE
  end

  def getMap
    @map
  end
end

