require_relative 'personnage'

class Heros < Personnage
  attr_reader :img

  def initialize x, y
    super x, y, sizeX, sizeY, "resources/mario.png"
    @x = x
    @y = y
    @sizeX = 50
    @sizeY = 50
  end

  def draw
    ratioX = @sizeX.to_f/self.width.to_f
    ratioY = @sizeY.to_f/self.height.to_f
    super @x, @y, 0, ratioX, ratioY
  end
end