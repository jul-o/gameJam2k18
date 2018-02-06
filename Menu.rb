require_relative 'Bouton'

class Menu < Gosu::Window

  # Dimension fenêtre du menu
  @@WIDTH = 1000
  @@HEIGHT = 600

  def initialize
    @nom = "Menu NOMDUJEU"

    @bouton = Bouton.new(self, "PD PD PD PD", @@HEIGHT/2, @@HEIGHT/2)

    super @@WIDTH, @@HEIGHT, options = {:fullscreen => false}
    self.caption = @nom
    self.show
  end

  def draw
    @bouton.draw
    draw_rect(mouse_x,mouse_y,20,20,Color.argb(255,255,255,255))
  end

end