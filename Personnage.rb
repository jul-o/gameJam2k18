
module Direction
  STATIC = -1
  LEFT = [-1,0]
  RIGHT = [1,0]
  UP = [0,-1]
  DOWN = [0,1]
end

class Personnage
  # Getter sur les attributs
  attr_accessor :x, :y, :velocity, :sizeX, :sizeY, :tourneVersDroite

  # Constantes de classe
  #GRAVITY_Y = 9*Game.FPS/60

  def initialize map, x, y, velocity, sizeX, sizeY, spriteGauche, spriteDroite
    # Création  des sprites gauche\droite
    @GRAVITY_Y = 2#*Game.FPS/60
    
    @spG = Gosu::Image.new(spriteGauche, :retro => true)
    @spD = Gosu::Image.new(spriteDroite, :retro => true)

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
    @ratioX = @sizeX.to_f/@spD.width.to_f
    @ratioY = @sizeY.to_f/@spD.height.to_f  

    # Booléens
    @tourneVersDroite = true
    @jumping = false
  end

  # Dessin de l'image courante
  def draw
    if @tourneVersDroite then
      img = @spD
    else
      img = @spG      
    end      
    img.draw @x, @y, 1, @ratioX, @ratioY
  end

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
      @vY = 0
    end

    if @vY > 0
      arrondiN(@vY).times { if @map.obstAt?([@x,@y+1])
                  then @vY = 0; @jumping = false
                  else @y += 1 end }
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

end