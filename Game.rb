require_relative 'heros'
class Game < Gosu::Window

  # Dimensions map : 24x14

  def initialize
    @nom = "GameJam"
    @bg = Gosu::Image.new("resources/bgcases.png")
    @width = 3*255
    @height = 3*210
    @heros = Heros.new 0, 0

    super @width, @height, options = {:fullscreen => false}
    caption = @NOM

    self.show
  end

  def draw
    fx = @width.to_f/@bg.width.to_f
    fy = @height.to_f/@bg.height.to_f
    @bg.draw(0, 0, 0, fx, fy)
    @heros.draw(0,0,0)
  end
end

