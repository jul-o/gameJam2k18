include Gosu

class Bouton

  def initialize(window, text, y, z)
    @window = window
    @image = Image.new("resources/Fond-rouge.jpg")
    @imageHover = Image.new("resources/Fond-rouge.jpg")
    @text = Image.from_text(window, text, "resources/SIXTY.TTF", 40)
    @y = y
    @z = z
  end


  def draw
    if isHover
      @imageHover.draw(@window.width/2-@imageHover.width/2, @y, @z)
    else
      @image.draw(@window.width/2-@image.width/2, @y, @z)
    end
    @text.draw(@window.width/2-@image.width/2, @y, @z+1)
  end


  def isHover
    x = @window.mouse_x > @window.width/2 - @image.width/2 && @window.mouse_x < @window.width/2 - @image.width/2 + @image.width
    y = @window.mouse_y > @window.height/2 - @image.height/2 - 514 +@y && @window.mouse_y < @window.height/2 - @image.height/2 + @image.height - 514 + @y
    return x == true && y == true
  end

end