include Gosu

class Credits < Window


  # Dimension fenêtre du menu
  @@WIDTH = 1200
  @@HEIGHT = 700

  def initialize
    @text = Image.from_text(self,"                                         Credits de Castle Invaders

    Codeurs : Nathan Boulanger
                        Habib Slim
                        Jules Sang
                        Leo Schmuck
    Designer en chef : Vincent de Jonge
    Aides-Designer : Leo Schmuck
                                        Habib Slim


Copyright ©",
                            "resources/retroComputer.ttf", 36)

    @bg = Image.new("resources/bg2.jpg")
    @curseur = Image.new("resources/curseur.png")

    @btn_retour = Bouton.new(self, "Retour", 550, 7)

    super @@WIDTH, @@HEIGHT, options = {:fullscreen => false}
    self.caption = @nom
    self.show
  end


  def draw
    fond
    self.draw_rect(20, 20, self.width - 40, self.height - 40, Color.argb(200, 180, 70, 70), 5)
    @text.draw(70, 70, 10, 1, 1, Color.argb(255, 255, 255, 255))
    @btn_retour.draw
  end

  def update
    if @btn_retour.isClick
      close
      $menu = Menu.new.show
    end
  end


  def fond
    @curseur.draw(mouse_x ,mouse_y, 30)
    @bg.draw(0, 0, -10)
  end

end