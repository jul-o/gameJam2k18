require_relative 'Heros'
require_relative 'Map'
require_relative 'Mechant'
require_relative 'Spawn'

class Game < Gosu::Window
  # @@FPS = 60
  # @@REFRESH_RATE = 1000/@@FPS

  @@WIDTH, @@HEIGHT = 765, 627

  # Dimensions map : 24x14

  def initialize
    @nom = "GameJam"

    # Création de la map et du héros
    @map = Map.new
    @heros = Heros.new @map, 1, 10
    
    # Fond d'écran
    @bg = Gosu::Image.new("resources/bg.jpg")
    @mechants = Array.new
    @spawns = initSpawns

    @perdu = false

    super @@WIDTH, @@HEIGHT, options = {:fullscreen => false}

    self.show
  end

  def initSpawns
    [Spawn.new(8, 2, 20, @map)]
  end

  def draw
    @bg.draw(0, 0, 0)
    @heros.draw
    @map.draw

    # Si le joueur n'a pas perdu, on spawne des méchants
    if !@perdu then
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
    if(!@perdu) then
      # Déplacement du personnage
      @heros.setDirection(Direction::LEFT) if Gosu::button_down?(Gosu::KbLeft)
      @heros.setDirection(Direction::RIGHT) if Gosu::button_down?(Gosu::KbRight)
      @heros.jump if Gosu::button_down?(Gosu::KbUp)
      
      # Attaques
      @heros.shoot if Gosu::button_down?(Gosu::KbX)

      # Mise à jour des déplacements
      @heros.move
      @mechants.each {|m| m.move}

      # On regarde si le héros est touché par un mechant
      if (perdu?)
        puts "AHAH PERDU MISKINE FDP"
        @perdu = true
      end
      
      testeBalleTouche
    end

    close if Gosu::button_down?(Gosu::KbEscape)
  end

  def testeBalleTouche

    @mechants.each do |mechant|

      @heros.gun.bullets.each do |key, bullet|
        xM = mechant.x
        yM = mechant.y
        wM = mechant.sizeX
        hM = mechant.sizeY


        xB = bullet.x
        yB = bullet.y
        wB = Projectile.SIZE[0]
        hB = Projectile.SIZE[1]

        #test collision verticale
        collisionH = (xM + wM >= xB && xM <= xB || xM <= xB + wB && xM + wM >= xB + wB)
        collisionV = (yM + hM >= yB && yM <= yB || yM <= yB + hB && yM + hM >= yB + hB)

        if collisionH && collisionV
          @mechants.delete mechant
          @heros.gun.bullets.delete key
        end
      end
    end
  end

  # Vérifie si le héros est touché par un monstre ou non
  # ==> Vrai si en contact
  def perdu?
    @mechants.each {|m|
      mX = m.x
      mY = m.y

      # Coordonnées du personnage
      x = @heros.x
      y = @heros.y

      rect1 = [x, y, Heros.SIZE[0], Heros.SIZE[1]]
      rect2 = [mX, mY, m.sizeX, m.sizeY]

      if ((rect1[0] < rect2[0] + rect2[2] && rect1[0] + rect1[2] > rect2[0]) &&
          (rect1[1] < rect2[1] + rect2[3] && rect1[3] + rect1[1] > rect2[1]))
        return true
      end
    }
    return false
  end

  # Getters
  def self.WIDTH
    @@WIDTH
  end

  def self.HEIGHT
    @@HEIGHT
  end

  # def self.FPS
  #   @@FPS
  # end

  def self.CELLSIZE
    @@CELLSIZE
  end

  def getMap
    @map
  end
end

