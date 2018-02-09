include Gosu

require_relative 'Bouton'
require_relative 'Menu'

class Perdu < Window


  # Dimension fenêtre du menu
  @@WIDTH = 1200
  @@HEIGHT = 700

  def initialize
    @text = Image.from_text("VOUS AVEZ PERDU !", 40, :font => "resources/retroComputer.ttf", :width => 1200, :align => :center)
    @bg = Image.new("resources/menu/bgMenu.png")
    @curseur = Image.new("resources/menu/curseur.png")

    @btn_retour = Bouton.new(self, "retour", 550, 7)

    super @@WIDTH, @@HEIGHT, options = {:fullscreen => false}
    self.caption = @nom
    self.show
  end


  def draw
    fond
    self.draw_rect(20, 20, self.width - 40, self.height - 40, Color.argb(200, 1, 0, 200), 5)
    @text.draw(0, 250, 10, 1, 1, Color.argb(255, 255, 255, 255))
    @btn_retour.draw
  end

  def update
    if @btn_retour.isClick
      sleep 0.2
      $menu = Menu.new
      close
    end
  end


  def fond
    @curseur.draw(mouse_x ,mouse_y, 30)
    @bg.draw(0, 0, -10)
  end
end