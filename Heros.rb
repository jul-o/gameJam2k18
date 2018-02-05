require_relative 'Personnage'

class Heros < Personnage
  attr_reader :img

  def initialize x, y
    super x, y, sizeX, sizeY, "resources/mario.png"

    # Définition des variables
    @x = x
    @y = y
    @sizeX = 50
    @sizeY = 50
    @velocityX = 0
    @velocityY = 0

    # Définition du ratio
    @ratioX = @sizeX.to_f/self.width.to_f
    @ratioY = @sizeY.to_f/self.height.to_f
  end

  def draw
    super @x, @y, 0, @ratioX, @ratioY
  end

  def jump
    @velocityY -= 0.4
  end

  def move
    @x += @velocityX
    @x %= Game.WIDTH
    @y += @velocityY
    @y %= Game.HEIGHT
    @velocityX = 0
    @velocityY *= 0.96
  end
end