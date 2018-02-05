class Game < Gosu::Window

  # Dimensions map : 24x14

  def initialize
    @NOM = "GameJam"
    @bg = Gosu::Image.new("resources/bg.jpg")

    super Gosu::screen_width, Gosu::screen_height, options = {:fullscreen => false}

    self.caption = @NOM

    self.show
  end

  def draw
    @bg.draw(0, 0, 0)
  end
end