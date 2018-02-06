class Spawn
  def initialize x, y, nbMechants, map, intervalMin = 30, ennemyRate = 60
    @x = x
    @y = y
    coordPx = coordToPx [x, y]
    @xPx = coordPx[0]
    @yPx = coordPx[1]
    @nbMechantsRestants = nbMechants
    @map = map
    @img = Gosu::Image.new("resources/marioD.png")
    @intervalMin = intervalMin
    @intervalC = 0
    @ennemyRate = ennemyRate
  end

  def tick
    @img.draw(@xPx, @yPx, 0, 0.1, 0.1)
    return peutEtreMechant
  end

  def peutEtreMechant
    if(@intervalC >= @intervalMin)
      if (rand*@ennemyRate).to_i == 1
        @intervalC = 0
        return Mechant.new @map, @x, @y
      else
        return 1
      end
    else
      @intervalC += 1
      return 1
    end
  end

  def coordToPx(coord)
    x = (coord[0]*(Game.WIDTH/Map.WX.to_f)).to_i
    y = (coord[1]*(Game.HEIGHT/Map.HY.to_f)).to_i

    return [x,y]
  end
end