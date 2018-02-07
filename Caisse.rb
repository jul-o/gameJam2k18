class Caisse
  SPRITE = "resources/caisse-bleue.gif"
  SIZE_X = 50
  SIZE_Y = 50

  def initialize x, y, map
    @map = map
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

  def ramassed #retourne un gun aléatoire

  end

  def pxToCoord
    rx = (((@xPx.to_f+SIZE_X)/Game.WIDTH)*Map.WX).to_i
    ry = (((@yPx.to_f+SIZE_Y)/Game.HEIGHT)*Map.HY).to_i

    return [rx,ry]
  end
end