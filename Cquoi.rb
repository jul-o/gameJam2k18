include Gosu

class Cquoi


  def initialize(window, text)
    @window = window
    @text = Image.from_text(window, text, "resources/SIXTY.TTF", 40)
  end


  def draw
    @window.draw_rect(20, 20, @window.width - 40, @window.height - 40, Color.argb(220, 180, 70, 70), 5)
    @text.draw(70, 70, 10, 1, 1, Color.argb(255, 255, 255, 255))
  end

end