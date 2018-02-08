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

    @frameAnimX = 0
    @frameAnimY = 0
  end

  def tick
    @img.draw(@xPx -50, @yPx, 0, SIZE_X / @img.width, SIZE_Y / @img.height)
    if @frameAnimX < 30
      @xPx += 1
      @frameAnimX +=1
    elsif @frameAnimX < 90
      @xPx -= 1
      @frameAnimX +=1
    elsif @frameAnimX < 120
      @xPx += 1
      @frameAnimX += 1
    else
      @frameAnimX = 0
    end

    if @frameAnimY < 100
      if @frameAnimY%5 == 0
        @yPx -= 1
      end
      @frameAnimY += 1
    elsif @frameAnimY < 200
      if @frameAnimY%5 == 0
        @yPx += 1
      end
      @frameAnimY += 1
    else
      @frameAnimY = 0
    end


    #@x = self.pxToCoord[0]
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

  def pxToCoord
    rx = (((@xPx.to_f+SIZE_X)/Game.WIDTH)*Map.WX).to_i
    ry = (((@yPx.to_f+SIZE_Y)/Game.HEIGHT)*Map.HY).to_i

    return [rx-1,ry-1]
  end
end