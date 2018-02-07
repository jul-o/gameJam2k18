class Spawn
  SIZE_X = 200
  SIZE_Y = 100
  def initialize x, y, map, intervalMin = 30, ennemyRate = 60
    @x = x
    @y = y
    coordPx = Map.coordToPx [x, y]
    @xPx = coordPx[0]
    @yPx = coordPx[1]
    @map = map
    @img = Gosu::Image.new("resources/ovni.png")
    @intervalMin = intervalMin
    @intervalC = 0
    @ennemyRate = ennemyRate
  end

  def tick
    @img.draw(@xPx -50, @yPx, 0, SIZE_X / @img.width, SIZE_Y / @img.height)
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