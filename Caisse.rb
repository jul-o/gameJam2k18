class Caisse
  SPRITE1 = "resources/caisse-bleue.gif"
  SPRITE2 = "resources/caisse-rouge.gif"
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
    @frameCligno = 0

    @img1 = Gosu::Image.new(SPRITE1, :retro => true)
    @img2 = Gosu::Image.new(SPRITE2, :retro => true)
  end

  def draw shakeX, shakeY
    if @frameCligno < 30
      @img1.draw(@xPx+shakeX, @yPx+shakeY, 0, SIZE_X/@img1.width, SIZE_Y/@img1.height)
      @img2.draw(@xPx+shakeX, @yPx+shakeY, 0, SIZE_X/@img2.width, SIZE_Y/@img2.height, Gosu::Color.new(0,0,0,0))
    elsif @frameCligno < 60
      @img1.draw(@xPx+shakeX, @yPx+shakeY, 0, SIZE_X/@img1.width, SIZE_Y/@img1.height, Gosu::Color.new(0,0,0,0))
      @img2.draw(@xPx+shakeX, @yPx+shakeY, 0, SIZE_X/@img2.width, SIZE_Y/@img2.height)
    else
      @img1.draw(@xPx+shakeX, @yPx+shakeY, 0, SIZE_X/@img1.width, SIZE_Y/@img1.height, Gosu::Color.new(0,0,0,0))
      @img2.draw(@xPx+shakeX, @yPx+shakeY, 0, SIZE_X/@img2.width, SIZE_Y/@img2.height)
      @frameCligno = 0
    end
    @frameCligno += 1
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