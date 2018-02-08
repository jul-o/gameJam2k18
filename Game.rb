require_relative 'Heros'
require_relative 'Map'
require_relative 'Mechant'
require_relative 'Spawn'
require_relative 'Caisse'
require_relative 'Perdu'
require_relative 'Son'

class Game < Gosu::Window

  attr_writer :framesTextVitesse
  # @@FPS = 60
  # @@REFRESH_RATE = 1000/@@FPS

  @@WIDTH, @@HEIGHT = 765, 627
  @@INSTANCE = nil

  NB_FRAMES_TEXT_BOSS = 90

  ID_SON_GONG = 7

  # Temps de l'effet de secousse
  SHAKE_FREQ = 50
  SHAKE_DURATION = 100
  
  # Dimensions map : 24x14

  def initialize
    @nom = "Castle Invaders"
    @@INSTANCE = self

    # Création de la map et du héros
    @map = Map.new
    @heros = Heros.new @map, 1, 10
    
    # Fond d'écran
    @imageEtoiles = Gosu::Image.new("resources/fondEtoile.png", :retro=>true)
    @imageEtoiles2 = Gosu::Image.new("resources/fondEtoile.png", :retro=>true)
    @xEtoiles = -@@WIDTH
    @xEtoiles2 = 0
    @frameEtoiles = 0

    @bg = Gosu::Image.new("resources/bg.png", :retro=>true)
    @bgRatio = @@WIDTH.to_f/@bg.width

    AlienType::ALLMOBS.each {|m|
      m[5] = m[7]
    }

    @mechants = Array.new
    @spawns = initSpawns

    # Nombre de caisses récupérées
    @nbCaisses = 0
    @texteNbCaisse = Gosu::Image.from_text("SCORE : 0", 22, :font => "resources/retroComputer.ttf", :width => 155, :align => :center)


    @perdu = false

    @caisse = Caisse.new (rand*15).to_i + 1, (rand * 13).to_i + 1, @map

    @nbCaisses = 0
    @apBossed = false
    @caissesBoss = [2]
    @bossTousLesCaisses = 10
    @imageTextBoss = Gosu::Image.from_text("Il arrive...", 50, :font => "resources/SIXTY.ttf")
    @imageTextVitesse = Gosu::Image.from_text("La vitesse augmente !", 50, :font => "resources/SIXTY.ttf")
    #@imageFondTexteBoss = Gosu::Image()

    super @@WIDTH, @@HEIGHT, options = {:fullscreen => false}
    @framesTextBoss = 0
    @framesTextVitesse = 0

    initialiseTexteArme

    # Shake X\Y
    @shakeX,@shakeY,@shakingDate,@shakeStartDate = 0,0,0,0
    @shakeVal = []
    @shakeBool = [1,-1]
    @shaking = false

    self.shake(10,10)

    # On initialise tous les sons
    Son.INST
    #self.show
  end

  def initSpawns
    [Spawn.new(8, 0, @map, @mechants, self)]
  end

  def draw
    # Dessin des éléments principaux de l'écran
    @bg.draw(@shakeX, @shakeY, -1, @bgRatio, @bgRatio)
    @heros.draw @shakeX, @shakeY
    @map.draw @shakeX, @shakeY
    @caisse.draw @shakeX, @shakeY

    @imageEtoiles.draw(@xEtoiles,0,-2, self.width.to_f/@imageEtoiles.width.to_f, self.height.to_f/@imageEtoiles.height.to_f)
    @imageEtoiles2.draw(@xEtoiles2,0,-2, self.width.to_f/@imageEtoiles.width.to_f, self.height.to_f/@imageEtoiles.height.to_f)
    @frameEtoiles += 1
    if(@frameEtoiles == 4)
      @xEtoiles += 1
      @xEtoiles2 += 1
      @frameEtoiles = 0
    end
    if @xEtoiles >= self.width
      @xEtoiles = -self.width
    end
    if @xEtoiles2 >= self.width
      @xEtoiles2 = -self.width
    end

    # Si le joueur n'a pas perdu, on spawne des méchants
    @caissesBoss.each {|n|
      if @nbCaisses == n && !@apBossed

        @spawns[0].apBoss
        @apBossed = true
        @framesTextBoss = NB_FRAMES_TEXT_BOSS
        @caissesBoss.delete n
        Son.INST.playSon(ID_SON_GONG)
      end
    }
    if @nbCaisses%@bossTousLesCaisses == 0 && @nbCaisses != 0 && !@apBossed

      @spawns[0].apBoss
      @apBossed = true
      @framesTextBoss = NB_FRAMES_TEXT_BOSS
      Son.INST.playSon(ID_SON_GONG)
    end

    if @framesTextBoss != 0
      @imageTextBoss.draw(self.width/2 - @imageTextBoss.width/2,self.height/2 - @imageTextBoss.height/2 - 50,1,1,1,Color.argb(255*@framesTextBoss/60, 255, 255, 255))
      Gosu::draw_rect(0,self.height/2 - @imageTextBoss.height/2 - 75,self.width,100,Gosu::Color.new(150*@framesTextBoss/60,0,0,0))

      @framesTextBoss -= 1
    end


    if @framesTextVitesse != 0 && @framesTextBoss == 0
      puts @framesTextVitesse
      @imageTextVitesse.draw(self.width/2 - @imageTextVitesse.width/2,self.height/2 - @imageTextVitesse.height/2 - 50,1,1,1,Color.argb(255*@framesTextVitesse/60, 255, 255, 255))
      Gosu::draw_rect(0,self.height/2 - @imageTextVitesse.height/2 - 75,self.width,100,Gosu::Color.new(150*@framesTextVitesse/60,0,0,0))

      @framesTextVitesse -= 1
    end

    if !@perdu then
      @spawns.each {|s|
        resSpawn = s.tick
        if !(resSpawn === 1)
          @mechants.push resSpawn
        end
      }
      @mechants.each do |m|
        m.draw @shakeX, @shakeY
      end
    end

    # On affiche le nom de l'arme en haut a gauche
    @listeArme[@indiceArmeCourante].draw(@shakeX+60,@shakeY+16,4,1,1,Gosu::Color.argb(255,255,255,255))

    @texteNbCaisse.draw(@shakeX+550,@shakeY+16,4,1,1,Gosu::Color.argb(255,255,255,255))
end

  def bossInstanciated
    @mechants.each {|mechant|
      if mechant.typePers == TYPE_BOSS
        return true
      end
    }
  end

  def update
    # Si le joueur a perdu, on prend son manteau et on s'en va
    if @perdu && !@shaking then
    end

    if(!@perdu) then
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
        sleep 0.7
        @perdu = true
        shake(10,10)      
        close
        $perdu = Perdu.new  
      end
      
      testeBalleTouche
      testeRamasseCaisse

      supprimeMort

      # Animation de shaking
      if @shaking then
        # Si l'animation est finie on prend son manteau et on s'en va
        if (Gosu.milliseconds - @shakeStartDate >= SHAKE_DURATION) then
          @shaking = false
          @shakeX = 0
          @shakeY = 0

        else
          if (Gosu.milliseconds - @shakingDate >= SHAKE_FREQ) then
            @shakeX = rand(1..@shakeVal[0])*@shakeBool[0]
            @shakeY = rand(1..@shakeVal[1])*@shakeBool[1]
            
            # On inverse le shake pour la fois d'après
            @shakeBool[0] *= -1
            @shakeBool[1] *= -1

            @shakingDate = Gosu.milliseconds
          end
        end
      end
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
      #puts @indiceArmeCourante
      @caisse = Caisse.new (rand*15).to_i + 1, (rand * 13).to_i + 1, @map
      @nbCaisses += 1

      @apBossed = false
      @texteNbCaisse = Gosu::Image.from_text("SCORE : #{@nbCaisses}", 22, :font => "resources/retroComputer.ttf", :width => 155, :align => :center)

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
      if (!m.isDead)
        mX = m.x
        mY = m.y

        # Coordonnées du personnage
        x = @heros.x
        y = @heros.y

        rect1 = [x, y, Heros.SIZE[0], Heros.SIZE[1]]
        rect2 = [mX, mY - m.sizeY + 50, m.sizeX, m.sizeY]

        if isHit?([rect1[0],rect1[1]],[rect2[0],rect2[1]],[rect1[2],rect1[3]],[rect2[2],rect2[3]])
          return true
        end
      end
    }
    return false
  end

  def supprimeMort
    @mechants.each do |m|
      if (m.isEscaped)
        @mechants.delete(m)
        @nbCaisses = @nbCaisses-1
        @texteNbCaisse = Gosu::Image.from_text("SCORE : #{@nbCaisses}", 22, :font => "resources/retroComputer.ttf", :width => 155, :align => :center)
      end
    end
  end

  # Lance l'animation de shaking
  def shake(x,y)
    if !@shaking then
      @shaking = true
      @shakeVal = [x,y]
      @shakingDate = Gosu.milliseconds - SHAKE_FREQ
      @shakeStartDate = Gosu.milliseconds
    end
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