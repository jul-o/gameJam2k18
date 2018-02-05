class Personnage < Gosu::Image
  attr_accessor :x, :y, :sizeX, :sizeY

  def initialize x, y, sizeX, sizeY, imgSrc
    @x = x
    @y = y
    @sizeX = sizeX
    @sizeY = sizeY
  end

end