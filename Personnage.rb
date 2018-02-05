module Direction
  LEFT = 0
  RIGHT = 1
  UP = 2
end

class Personnage < Gosu::Image
  # Getter sur les attributs
  attr_accessor :x, :y, :sizeX, :sizeY

  def initialize x, y, sizeX, sizeY, imgSrc
    super imgSrc
    @x = x
    @y = y
    @sizeX = sizeX
    @sizeY = sizeY
  end

  def setDirection(dir)
    case dir
      when Direction::LEFT 
        @velocityX -= 0.4
      when Direction::RIGHT
        @velocityX += 0.4
    end
    
    # Ici : changer l'image par rapport à la direction
  end
end