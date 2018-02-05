module Direction
  LEFT = 0
  RIGHT = 1
  UP = 2
end

class Personnage < Gosu::Image
  # Getter sur les attributs
  attr_accessor :x, :y, :velocity, :sizeX, :sizeY

  def initialize x, y, velocity, sizeX, sizeY, imgSrc
    super imgSrc
    @x = x
    @y = y
    @sizeX = sizeX
    @sizeY = sizeY
    @velocity = velocity
  end

  def setDirection(dir)
    case dir
      when Direction::LEFT 
        @velocityX -= @velocity
      when Direction::RIGHT
        @velocityX += @velocity
    end

    # Ici : changer l'image par rapport à la direction
  end
end