class Spawn
  SIZE_X = 200
  SIZE_Y = 100
  def initialize x, y, map, intervalMin = 30, ennemyRate = 90, tabMechants
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
    @bossWait = false
    @tabMechants = tabMechants
  end

  def tick
    @img.draw(@xPx -50, @yPx, 0, SIZE_X / @img.width, SIZE_Y / @img.height)
    return peutEtreMechant
  end

  def peutEtreMechant
    @intervalC += 1
    if(@intervalC >= @intervalMin)
      if (!@bossWait)

        if (rand*@ennemyRate).to_i == 1
          @intervalC = 0
          mechant = Mechant.new AlienType.RND,@map, @x, @y
          if((rand * 2).to_i == 0)
            mechant.tourner
          end
          return mechant
        end

      end

    end

    if @bossWait && @tabMechants.empty?
      @bossWait = false
      mechant = Mechant.new AlienType.RND_BOSS,@map, @x, @y
      if((rand * 2).to_i == 0)
        mechant.tourner
      end
      #puts mechant
      return mechant
    end

    return 1


  end

  def apBoss
    @bossWait = true
  end
end