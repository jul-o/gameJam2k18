class Game < Gosu::Window

  # Dimensions map : 24x14

  def initialize
    @NOM = "GameJam"
    @bg = Gosu::Image.new("resources/bg.jpg")
    @width = Gosu::screen_width
    @height = Gosu::screen_height

    super @width, @height, options = {:fullscreen => false}
    caption = @NOM

    self.show
  end

  def draw
    fx = @width.to_f/@bg.width.to_f
    fy = @height.to_f/@bg.height.to_f
    @bg.draw(0, 0, 0, fx, fy)
  end
end