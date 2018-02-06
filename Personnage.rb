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
        @velocityX -= @velocity
      when Direction::RIGHT        
        if !@tourneVersDroite
          @tourneVersDroite = true
        end
        @velocityX += @velocity
    end
    # Ici : changer l'image par rapport à la direction
  end

  def move    
    coord = pxToCoord

    # On récupère les obstacles autour du menz
    allObst = @map.obstacleAround(coord)

    # On ajoute la gravité (si le personnage ne saute pas)
    @velocityY += @jumping ? 0 : GRAVITY_Y

    if (allObst.length>0) then
      allObst.each do |dirObst|
        # Pour chaque dir, si le menz a une vélocité dans la dir de l'obstacle
        # et qu'il est en contact avec la hitbox des obstacles => on annule la vélocité
        if (isHit?(dirObst)) then
          case dirObst
            when 0 # Haut
              @velocityY = 0 if @velocityY<0 
            when 1 # Bas
              @velocityY = 0 if @velocityY>0 
            when 2 # Droite
              @velocityX = 0 if @velocityX>0 
            when 3 # Gauche
              @velocityX = 0 if @velocityX<0 
          end
        end
      end
    end

    # et on calcule la nouvelle position du bolosse (si on ne sort pas du cadre)
    @x += @velocityX if (0..Game.WIDTH) ===(@x + @velocityX)
    @y += @velocityY if (0..(Game.HEIGHT - @sizeY))===(@y + @velocityY)

    @velocityX = 0
    @velocityY *= 0.96
  end

  # Fait la conversion coordpx => coordgrille
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

  # Renvoie true s'il y a collision entre l'obstacle (oX,oY)
  # et le personnage
  def isHit?(dir)
    # Coordonnées de l'obstacle
    oX = dir[0] + pxToCoord[0]
    oY = dir[1] + pxToCoord[1]

    rect1 = [@x, @y, @sizeX, @sizeY]
    rect2 = coordToPx([oX,oY]) + [@sizeX, @sizeY]
  
    puts "HitboxP : "
    puts rect1
    puts "HitboxO : "
    puts rect2

    return ((rect1[0] < rect2[0] + rect2[2] && rect1[0] + rect1[2] > rect2[0]) &&
            (rect1[1] < rect2[1] + rect2[3] && rect1[3] + rect1[1] > rect2[1])) 
  end
end