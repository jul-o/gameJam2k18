include Gosu

class Bouton

  # Dimension de l'image du bouton
  @@Image_WIDTH = 437
  @@Image_HEIGHT = 70


  # Un bouton est centré en x et n'a donc besoin que d'une fenêtre, d'un texte et de coordonnées en y et z
  def initialize(window, text, y, z, iconHover = "")
    @window = window
    # @text1 = Image.from_text(text, 40, :font => "resources/retroComputer.ttf")
    @image =      Image.new("resources/menu/#{text}N.png")
    @imageHover = Image.new("resources/menu/#{text}H.png")
    @y = y
    @z = z
  end


  def draw
    # Affiche la bonne image en fonction de si le curseur est sur le bouton ou pas
    if isHover
      @imageHover.draw(@window.width/2 - @imageHover.width/2, @y, @z)
      if @iconHover != nil
        @iconHover.draw(@window.width/2 - @imageHover.width/2 + 5, @y + @image.height/2 - 32, @z+1)
      end
    else
      @image.draw(@window.width/2 - @image.width/2, @y, @z)
    end
    # Centre le texte
    # @text1.draw(@window.width/2 - @text1.width/2, @y + @image.height/2 - @text1.height/2, @z+1, 1, 1, Color.argb(255, 255, 255, 255))
  end


  # Permet de détecter si la souris se trouve sur le bouton
  def isHover
    x = @window.mouse_x > @window.width/2 - @image.width/2 - 5 && @window.mouse_x < @window.width/2 + @image.width/2 - 3
    y = @window.mouse_y > @y && @window.mouse_y < @y + @image.height
    return x == true && y == true
  end

  def getImg_Width
    @@Image_WIDTH
  end

  def getImg_Height
    @@Image_HEIGHT
  end

  def getY
    @y
  end

  def isClick
    x = @window.mouse_x > @window.width/2 - @image.width/2 && @window.mouse_x < @window.width/2 + @image.width
    y = @window.mouse_y > @y && @window.mouse_y < @y + @image.height
    if button_down?(MS_LEFT)
      return x == true && y == true
    end
  end

end