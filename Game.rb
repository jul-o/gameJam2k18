require_relative 'Heros'
require_relative 'Map'
require_relative 'Mechant'
require_relative 'Spawn'
require_relative 'Caisse'

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

    @caisse = Caisse.new 1,2, @map

    super @@WIDTH, @@HEIGHT, options = {:fullscreen => false}

    initialiseTexteArme

    self.show
  end

  def initSpawns
    [Spawn.new(8, 0, @map)]
  end

  def draw
    @bg.draw(0, 0, -1)
    @heros.draw
    @map.draw
    @caisse.draw

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

    # On affiche le nom de l'arme en haut a gauche
    @listeArme[@indiceArmeCourante].draw(50,50,4,1,1,Gosu::Color.argb(255,255,255,255))

  end

  def update
    if(!@perdu) then
      # Déplacement du personnage
      @heros.setDirection(Direction::LEFT) if Gosu::button_down?(Gosu::KbLeft)
      @heros.setDirection(Direction::RIGHT) if Gosu::button_down?(Gosu::KbRight)
      @heros.jump if Gosu::button_down?(Gosu::KbUp)
      
      # Attaques
      @heros.shoot if Gosu::button_down?(Gosu::KbX)
      @indiceArmeCourante = @heros.switchWeapon if Gosu::button_down?(Gosu::KbS)

      # Mise à jour des déplacements
      @heros.move
      @mechants.each {|m| m.move}

      # On regarde si le héros est touché par un mechant
      if (perdu?)
        puts "AHAH PERDU MISKINE FDP"
        @perdu = false #true
      end
      
      testeBalleTouche
      testeRamasseCaisse
    end

    close if Gosu::button_down?(Gosu::KbEscape)
  end

  def testeRamasseCaisse
    xC = @caisse.xPx
    yC = @caisse.yPx
    wC = Caisse.SIZE_X
    hC = Caisse.SIZE_Y

    xH = @heros.x
    yH = @heros.y
    wH = @heros.sizeX
    hH = @heros.sizeY

    if testeCollisionPx xC, yC, wC, hC, xH, yH, wH, hH
      @heros.switchWeapon
      @caisse = Caisse.new (rand*15).to_i + 1, (rand * 13).to_i + 1, @map
    end
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
        wB = bullet.sizeR
        hB = bullet.sizeR


        #test collision verticale
        if testeCollisionPx xM, yM, wM, hM, xB, yB, wB, hB
          @mechants.delete mechant
          @heros.gun.bullets.delete key
          break
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

      if testeCollisionPx rect1[0],rect1[1],rect1[2],rect1[3],rect2[0],rect2[1],rect2[2],rect2[3]
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
  def testeCollisionPx x1, y1, w1, h1, x2, y2, w2, h2
    collisionH = (x1 + w1 >= x2 && x1 <= x2 || x1 <= x2 + w2 && x1 + w1 >= x2 + w2)
    collisionV = (y1 + h1 >= y2 && y1 <= y2 || y1 <= y2 + h2 && y1 + h1 >= y2 + h2)

    oui = (x1 < x2 + w2 &&
        x1 + w1 > x2 &&
        y1 < y2 + h2 &&
        h1 + y1 > y2)

    return collisionH && collisionV
  end

  def initialiseTexteArme
    @listeArme = [Gosu::Image.from_text(self, "Fusil-à-pompe", "Arial", 20),
                  Gosu::Image.from_text(self, "BAZOOOKA", "Arial", 20)]
    @indiceArmeCourante = 0
  end
end

