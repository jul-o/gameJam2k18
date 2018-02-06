module Direction
  STATIC = -1
  LEFT = [-1,0]
  RIGHT = [1,0]
  UP = [0,-1]
  DOWN = [0,1]
end

class Personnage
  # Getter sur les attributs
  attr_accessor :x, :y, :velocity, :sizeX, :sizeY

  # Constantes de classe
  GRAVITY_Y = 9

  def initialize map, x, y, velocity, sizeX, sizeY, spriteGauche, spriteDroite
    # Création  des sprites gauche\droite
    @spD = Gosu::Image.new(spriteDroite)
    @spG = Gosu::Image.new(spriteGauche)

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
    @velocity = velocity

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
    img.draw @x, @y, 0, @ratioX, @ratioY    
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
    # Ici : changer l'image par rapport à la direction
  end

  def move    
    coord = pxToCoord

    # On ajoute la gravité (si le personnage ne saute pas)
    @vY += @jumping ? 0 : GRAVITY_Y

    # On teste si le personnage peut tenir dans toutes les directions
    # Haut\Bas
    if (@vY!=0) then
      @vY = 0 if (@map.obstAt?([@x,@y+@vY]))
    end
    # Droite\Gauche
    if (@vX!=0) then      
      @vX = 0 if (@map.obstAt?([@x+@vX,@y]))
    end

    # et on calcule la nouvelle position du bolosse (si on ne sort pas du cadre)
    @x += @vX if (0..(Game.WIDTH - @sizeX)) ===(@x + @vX)
    @y += @vY if (0..(Game.HEIGHT - @sizeY))===(@y + @vY)

    @vX = 0
    @vY *= 0.96
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

end