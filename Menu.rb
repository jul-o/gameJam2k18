require_relative 'Bouton'
require_relative 'Credits'
require_relative 'Cquoi'

class Menu < Gosu::Window

  # Dimension fenêtre du menu
  @@WIDTH = 1200
  @@HEIGHT = 700

  def initialize
    @nom = "Menu NOMDUJEU"

    # Définition des boutons
    @btn_jouer = Bouton.new(self, "Jouer", 180, 0)
    @btn_credit = Bouton.new(self, "Credits", 180 + 120, 0)
    @btn_cQuoi = Bouton.new(self, "C QUOI ?", 300 + 120, 0)
    @btn_quitter = Bouton.new(self, "Quitter", 420 + 120, 0, "resources/porte.png")

    # Définition du crédit
    @credit = Credits.new(self, "Chef de projet : X
    Codeurs : Nathan Boulanger
                  Habib Slim
                  Jules Sang
                  Leo Schmuck
    Designer en chef : Vincent de Jonge
    Aides-Designer : Leo Schmuck
                           Habib Slim

    Copyright
")


    # Définition du cQuoi
    @cquoi = Cquoi.new(self, "                                      NOMDUJEU est un Die 'N Retry.

                            Le principe est de ramasser les caisses afin de passer
                            à un niveau superieur tout en evitant de mourir.
                            Pour ce faire, des armes sont disponibles dans ces
                            dernieres pour que vous puissiez vous défendre.


                                            Bon Chance...
")


    @bg = Gosu::Image.new("resources/bg2.jpg")
    @curseur = Gosu::Image.new("resources/curseur.png")

    super @@WIDTH, @@HEIGHT, options = {:fullscreen => false}
    self.caption = @nom
    self.show
  end

  def draw

    @btn_jouer.draw
    @btn_credit.draw
    @btn_cQuoi.draw
    @btn_quitter.draw

    if (mouse_x > @btn_jouer.getY && mouse_x < @btn_jouer.getY + @btn_jouer.getImg_Width && mouse_y > @btn_jouer.getY && mouse_y < @btn_jouer.getY + @btn_jouer.getImg_Height)
      if button_down?(MS_LEFT)
      end
    end

    if (mouse_x > @btn_credit.getY && mouse_x < @btn_credit.getY + @btn_credit.getImg_Width && mouse_y > @btn_credit.getY && mouse_y < @btn_credit.getY + @btn_credit.getImg_Height)
      if !button_down?(MS_LEFT)
        @credit.draw
      end
    end

    if (mouse_x > @btn_cQuoi.getY && mouse_x < @btn_cQuoi.getY + @btn_cQuoi.getImg_Width && mouse_y > @btn_cQuoi.getY && mouse_y < @btn_cQuoi.getY + @btn_cQuoi.getImg_Height)

      if !button_down?(MS_LEFT)
        @cquoi.draw
      end
    end

    if (mouse_x > @btn_quitter.getY && mouse_x < @btn_quitter.getY + @btn_quitter.getImg_Width && mouse_y > @btn_quitter.getY && mouse_y < @btn_quitter.getY + @btn_quitter.getImg_Height)
      if button_down?(MS_LEFT)
        exit
      end
    end


    @curseur.draw(mouse_x ,mouse_y, 30)
    @bg.draw(0, 0, -10)
  end
end
