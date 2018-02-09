module Direction
  STATIC = -1
  LEFT = [-1,0]
  RIGHT = [1,0]
  UP = [0,-1]
  DOWN = [0,1]
end

TYPE_MONSTRE = 1
TYPE_BOSS = 2
TYPE_HEROS = 0

class Personnage
  # Getter sur les attributs
  attr_accessor :x, :y, :velocity, :sizeX, :sizeY, :tourneVersDroite, :estMort, :typePers

  # Constantes de classe
  #GRAVITY_Y = 9*Game.FPS/60
  #?=
  DUREE_ANIMATION_COMPLETE_MS = 300
  BLINK_FREQ = 75
  BLINK_DURATION = 500
  #?=

  def initialize map, x, y, velocity, sizeX, sizeY, spriteGauche, spriteDroite, typePers
    # Création  des sprites gauche\droite
    @GRAVITY_Y = 2#*Game.FPS/60

    #?=
    @spD = Array.new
    spriteDroite.each do |sp|
      @spD.push(Gosu::Image.new(sp, :retro => true))
    end
    @spG = Array.new
    spriteGauche.each do |sp|
      @spG.push(Gosu::Image.new(sp, :retro => true))
    end
    
    # Génère une liste de sprite "blink"
    @blinkSPD = BlinkEffect.blink @spD
    @blinkSPG = BlinkEffect.blink @spG

    # Attributs pour animation
    @indiceSpriteCourant = 0
    @NBSPRITE = spriteGauche.length
    @dateMajSprite = 0.0

    @vX = 0.0
    #?=

    # Définition des attributs
    @map = map
    @lastDir = Direction::STATIC
    
    # Calcul de la position en pixels du personnage
    coordPx = coordToPx([x,y])
    @x = coordPx[0]
    @y = coordPx[1]

    # Définition des dimensions et vélocités
    @sizeX = sizeX
    @sizeY = sizeY
    @velocity = velocity#*Game.FPS/60

    # Calcul des ratios x\y
    @ratioX = @sizeX.to_f/@spD[0].width.to_f
    @ratioY = @sizeY.to_f/@spD[0].height.to_f

    # Booléens
    @tourneVersDroite = true
    @jumping = false

    # Blinking
    @blinking,@blinkNow = false,false
    @blinkT, @blinkDelay = 0
    # --

    # Mob ou non
    @typePers = typePers
    @escaped = false
    
    # Animation de mort du mob
    @mobDying = false
    @dyingAlpha = 255

    @bossVaAtterir = false
  end

  #?=
  # Dessin de l'image courante
  def draw shakeX,shakeY
    if @blinkNow then
      if @tourneVersDroite then
        img = @blinkSPD[@indiceSpriteCourant]
      else
        img = @blinkSPG[@indiceSpriteCourant]
      end
    else
      if @tourneVersDroite then
        img = @spD[@indiceSpriteCourant]
      else
        img = @spG[@indiceSpriteCourant]
      end
    end

    if @mobDying then
      img.draw @x+shakeX, @y+shakeY - @sizeY + 50, 1, @ratioX, @ratioY, Gosu::Color.new(@dyingAlpha,255,255,255)
    else
      img.draw @x+shakeX, @y+shakeY - @sizeY + 50, 1, @ratioX, @ratioY     
    end
  end

  def update
    if (@vX != 0.0)
      if (Gosu.milliseconds > @dateMajSprite + DUREE_ANIMATION_COMPLETE_MS/@NBSPRITE)
        indiceSpriteSuivant
        @dateMajSprite = Gosu.milliseconds
      end
    end

    # Clignotement
    if (@blinking) then
      if (Gosu.milliseconds > @blinkT + BLINK_DURATION) then
        @blinkNow = false
        @blinking = false
      else
        if (Gosu.milliseconds > @blinkDelay + BLINK_FREQ) then
          @blinkNow = !@blinkNow
          @blinkDelay = Gosu.milliseconds
        end
      end
    end
    
    # Animation de mort
    if (@mobDying) then
      @dyingAlpha -= 10
      if (@dyingAlpha <= 10) then
        # On supprime le sprite
        Game.INSTANCE.removeMob self
      end

      # On annule vX et vY
      @vX = 0
      @vY = 0
    end
  end

  def indiceSpriteSuivant
    if (@indiceSpriteCourant == @NBSPRITE-1)
      @indiceSpriteCourant = 0
    else
      @indiceSpriteCourant += 1
    end
  end
  #?=

  def setDirection(dir)
    @lastDir = dir

    # On prend en compte le mouvement effectué
    case @lastDir
      when Direction::LEFT        
        if @tourneVersDroite
          @tourneVersDroite = false
        end
        @vX -= @velocity
      when Direction::RIGHT        
        if !@tourneVersDroite
          @tourneVersDroite = true
        end
        @vX += @velocity
    end
  end

  def move    
    coord = pxToCoord

    # On teste si le personnage peut tenir à Droite\Gauche
    if (@vX!=0) then      
      @vX = 0 if (@map.obstAt?([@x+@vX,@y]))
    end

    # Gravité
    @vY += 1.5
    if !((0..(Game.HEIGHT - @sizeY)) ===(@y + @vY))
      # Si le menz dépasse de la map on l'arrete
      @vY = 0 if @typePers == TYPE_HEROS
      # Si c'est un monstre on le laisse dépasser mais on le déclare comme mort pour pouvoir le supprimer
      @escaped = true if @typePers == TYPE_MONSTRE
    end

    if (@vY == 1.5 && @bossVaAtterir)
      Game.INSTANCE.shake(6,11)
    end
    @bossVaAtterir = false

    if @vY > 0
      arrondiN(@vY).times {
        if @map.obstAt?([@x,@y+1], @typePers) then
          @vY = 0; @jumping = false
        else
          @y += 1
          @bossVaAtterir = true if @typePers == TYPE_BOSS
        end }
    end

    # et on calcule la nouvelle position du bolosse (si on ne sort pas du cadre)
    # on remet sa vitesse à 0 si il sort de la map
    if (0..(Game.WIDTH - @sizeX)) ===(@x + @vX)
      @x += @vX
    else
      @vX = 0
    end

    # On réactive le jump
    if (@y + @sizeY >= Game.HEIGHT)
      @jumping = false
    end

  end

  # Fait la conversion coordpx du personnage => coordgrille
  def pxToCoord
      rx = (((@x.to_f+@sizeX)/Game.WIDTH)*Map.WX).to_i
      ry = (((@y.to_f+@sizeY)/Game.HEIGHT)*Map.HY).to_i
  
      return [rx-1,ry-1]
  end

  # Fait la conversion coordgrille => coordpx
  def coordToPx(coord)     
    x = (coord[0]*(Game.WIDTH/Map.WX.to_f)).to_i
    y = (coord[1]*(Game.HEIGHT/Map.HY.to_f)).to_i

    return [x,y]
  end

  def arrondiN(i)
    return (i-0.5).to_i
  end

  def blink
    # Démarre l'animation de clignotement après la réception de dégâts
    if (!@blinking) then
      # On initialise les booléens
      @blinking = true

      # On initialise les timers
      @blinkT = Gosu.milliseconds
      @blinkDelay = @blinkT
    end
  end

end