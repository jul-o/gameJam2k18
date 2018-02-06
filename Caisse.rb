class Caisse
  attr_accessor :x, :y, :vY

  def initialize xSpawn, ySpawn
    @x = xSpawn
    @y = ySpawn
    @vY = 3
    @img = Gosu::Image.new("resources/marioD.png")
  end

  def tick map
    if(map.obstAt? [@x, @y])
      @vY = 0
    end
    @y += @vY
    puts @y
    @img.draw @x, @y, 0, 37.to_f/266.to_f, 50.to_f/355.to_f
  end

end