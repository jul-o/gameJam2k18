class Game < Gosu::Window

  # Dimensions map : 24x14

  def initialize
    @NOM = "GameJam"
    @BACKGROUND = Gosu::Image.new("resources/bg.jpg")

    super 1, 1, options = {:fullscreen => true}

    self.caption = @NOM

    self.show
  end

  def draw
    @BACKGROUND.draw(0,0,0)
  end
end