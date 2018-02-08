class Caisse
  SPRITE = "resources/caisse-bleue.gif"
  SIZE_X = 50
  SIZE_Y = 50

  attr_reader :xPx, :yPx

  def initialize x, y, map
    @map = map

    while (map.getCase ([x,y])) != 0 || y < 4
      x = (rand * 15).to_i + 1
      y = (rand * 13).to_i + 1
    end
  
    @x = x
    @y = y
    coordPx = Map.coordToPx([x, y])
    @xPx = coordPx[0]
    @yPx = coordPx[1]

    @img = Gosu::Image.new(SPRITE, :retro => true)
  end

  def draw
    @img.draw(@xPx, @yPx, 0, SIZE_X/@img.width, SIZE_Y/@img.height)
    deplacer
  end

  def deplacer
    if @map.getCase([@x, @y]) == 0
      @yPx += 5
      @x = pxToCoord[0]
      @y = pxToCoord[1]
    end
  end

  def pxToCoord
    rx = (((@xPx.to_f+SIZE_X)/Game.WIDTH)*Map.WX).to_i - 1
    ry = (((@yPx.to_f+SIZE_Y)/Game.HEIGHT)*Map.HY).to_i

    return [rx,ry]
  end

  def self.SIZE_X
    SIZE_X
  end

  def self.SIZE_Y
    SIZE_Y
  end
end