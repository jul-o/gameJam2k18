include Gosu

require_relative 'Bouton'
require_relative 'Menu'

class Cquoi < Window


  # Dimension fenêtre du menu
  @@WIDTH = 1200
  @@HEIGHT = 700

  def initialize
    @text1 = Image.from_text(self, "                                             Castle Invaders est un Die 'N Retry.

                    Le principe est de ramasser les caisses afin de passer
                          a un niveau superieur tout en evitant de mourir.
                      Pour ce faire, des armes sont disponibles dans ces
                          dernieres pour que vous puissiez vous défendre.

                                                        Bonne chance chevalier !", "resources/retroComputer.ttf", 26)

    @bg = Image.new("resources/bg2.jpg")
    @curseur = Image.new("resources/curseur.png")

    @text2 = Image.from_text(self, "Les personnages de Castle Invaders :", "resources/retroComputer.ttf", 26)
    @monstres = Image.new("resources/monstres.png")


    @btn_retour = Bouton.new(self, "Retour", 550, 7)

    super @@WIDTH, @@HEIGHT, options = {:fullscreen => false}
    self.caption = @nom
    self.show
  end


  def draw
    fond
    self.draw_rect(20, 20, self.width - 40, self.height - 40, Color.argb(200, 180, 70, 70), 5)
    @text1.draw(140, 140, 10, 1, 1, Color.argb(255, 255, 255, 255))
    @text2.draw(100, 410, 10, 1, 1, Color.argb(255, 255, 255, 255))
    @monstres.draw(self.width/2 - @monstres.width*3/2, 440, 5, 3, 3)
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