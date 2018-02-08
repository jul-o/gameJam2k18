require_relative 'Heros'
require_relative 'Map'
require_relative 'Mechant'
require_relative 'Spawn'
require_relative 'Caisse'
require_relative 'Perdu'

class Game < Gosu::Window
  # @@FPS = 60
  # @@REFRESH_RATE = 1000/@@FPS

  @@WIDTH, @@HEIGHT = 765, 627
  @@INSTANCE = nil
  
  # Dimensions map : 24x14

  def initialize
    @nom = "GameJam"
    @@INSTANCE = self

    # Création de la map et du héros
    @map = Map.new
    @heros = Heros.new @map, 1, 10
    
    # Fond d'écran
    @bg = Gosu::Image.new("resources/bg.png", :retro=>true)
    @bgRatio = @@WIDTH.to_f/@bg.width

    @mechants = Array.new
    @spawns = initSpawns

    @bool_perdu = false

    @caisse = Caisse.new (rand*15).to_i + 1, (rand * 13).to_i + 1, @map

    super @@WIDTH, @@HEIGHT, options = {:fullscreen => false}

    initialiseTexteArme

    #self.show
  end

  def initSpawns
    [Spawn.new(8, 0, @map)]
  end

  def draw
    @bg.draw(0, 0, -1, @bgRatio, @bgRatio)
    @heros.draw
    @map.draw
    @caisse.draw

    # Si le joueur n'a pas perdu, on spawne des méchants
    if !@bool_perdu then
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
    @listeArme[@indiceArmeCourante].draw(60,16,4,1,1,Gosu::Color.argb(255,255,255,255))

  end

  def update
    if(!@bool_perdu) then
      # Déplacement du personnage
      @heros.setDirection(Direction::LEFT) if Gosu::button_down?(Gosu::KbLeft)
      @heros.setDirection(Direction::RIGHT) if Gosu::button_down?(Gosu::KbRight)
      @heros.jump if Gosu::button_down?(Gosu::KbUp)
      
      # Attaques
      @heros.shoot if Gosu::button_down?(Gosu::KbX)

      # TEMPORAIRE
      if Gosu::button_down?(Gosu::KbS) then
        @indiceArmeCourante = @heros.switchWeapon 
      end

      # Mise à jour des déplacements
      @heros.move
      @mechants.each {|m| m.move}

      # Update des animations
      @heros.update
      @mechants.each {|m| m.update}

      # On regarde si le héros est touché par un mechant
      if (perdu?)
        sleep 1
        @bool_perdu = true
        close
        # $menu = Menu.new
        $perdu = Perdu.new
      end
      
      testeBalleTouche
      testeRamasseCaisse
    else
      $ETAT = $ETAT_PERDU
      close
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

    if isHit?([xH, yH], [xC, yC], [wH, hH], [wC, hC])
      # Changement de l'arme du héros et actualisation de l'arme courante
      @indiceArmeCourante = @heros.switchWeapon
      puts @indiceArmeCourante
      @caisse = Caisse.new (rand*15).to_i + 1, (rand * 13).to_i + 1, @map
    end
  end

  def testeBalleTouche
    @heros.gun.bullets.each do |key, bullet|      
      xB = bullet.pos[0]
      yB = bullet.pos[1]
      wB = bullet.sizeR
      hB = bullet.sizeR

      @mechants.each do |mechant|
          xM = mechant.x
          yM = mechant.y
          wM = mechant.sizeX
          hM = mechant.sizeY

          if isHit?([xM, yM], [xB,yB], [wM,hM], [wB,hB])
            # On inflige les dégâts du projectile au mob touché
            mechant.dealDMG bullet.degatsProj

            # => disparition du projectile si il ne doit pas exploser   
            @heros.gun.bullets.delete key if !bullet.explode 
          end
      end
    end
  end

  # Renvoie true s'il y a collision entre deux rectangles
  # et l'élément
  def isHit?(coordA, coordB, sizeA, sizeB)
    rect1 = [coordA[0], coordA[1], sizeA[0], sizeA[1]]
    rect2 = [coordB[0], coordB[1], sizeB[0], sizeB[1]]

    return ((rect1[0] < rect2[0] + rect2[2] && rect1[0] + rect1[2] > rect2[0]) &&
            (rect1[1] < rect2[1] + rect2[3] && rect1[3] + rect1[1] > rect2[1])) 
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

      if isHit?([rect1[0],rect1[1]],[rect2[0],rect2[1]],[rect1[2],rect1[3]],[rect2[2],rect2[3]])
        return true
      end
    }
    return false
  end

  # Méthode externe pour supprimer un mob de la liste
  def removeMob mob
    @mechants.delete mob
  end

  def getMap
    @map
  end

  def initialiseTexteArme
    @listeArme = [Gosu::Image.from_text("SHOTGUN",    22, :font => "resources/retroComputer.ttf", :width => 155, :align => :center),
                  Gosu::Image.from_text("BAZOOKA",    22, :font => "resources/retroComputer.ttf", :width => 155, :align => :center),
                  Gosu::Image.from_text("REVOLVER",   22, :font => "resources/retroComputer.ttf", :width => 155, :align => :center),
                  Gosu::Image.from_text("MACHINEGUN", 22, :font => "resources/retroComputer.ttf", :width => 155, :align => :center)]
    @indiceArmeCourante = 0
  end

  # Getters statiques
  def self.WIDTH
    @@WIDTH
  end

  def self.HEIGHT
    @@HEIGHT
  end

  def self.CELLSIZE
    @@CELLSIZE
  end

  def self.INSTANCE
    @@INSTANCE
  end
end

