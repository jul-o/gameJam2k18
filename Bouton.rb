include Gosu

class Bouton

  # Dimension de l'image du bouton
  @@Image_WIDTH = 462
  @@Image_HEIGHT = 97


  # Un bouton est centré en x et n'a donc besoin que d'une fenêtre, d'un texte et de coordonnées en y et z
  def initialize(window, text, y, z, iconHover = "")
    @window = window
    @text = Image.from_text(window, text, "resources/SIXTY.TTF", 50)
    @image = Image.new("resources/Fond-rouge-fonce.jpg")
    @imageHover = Image.new("resources/Fond-rouge.jpg")
    if iconHover != ""
      @iconHover = Image.new(iconHover)
    end
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
    @text.draw(@window.width/2 - @text.width/2, @y + @image.height/2 - @text.height/2, @z+1, 1, 1, Color.argb(255, 255, 255, 255))
  end


  # Permet de détecter si la souris se trouve sur le bouton
  def isHover
    x = @window.mouse_x > @window.width/2 - @image.width/2 && @window.mouse_x < @window.width/2 + @image.width
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