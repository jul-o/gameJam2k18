class Spawn
  def initialize x, y, map, intervalMin = 30, ennemyRate = 60
    @x = x
    @y = y
    coordPx = Map.coordToPx [x, y]
    @xPx = coordPx[0]
    @yPx = coordPx[1]
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
        mechant = Mechant.new @map, @x, @y
        if((rand * 2).to_i == 0)
          mechant.tourner
        end
        return mechant
      else
        return 1
      end
    else
      @intervalC += 1
      return 1
    end
  end
end