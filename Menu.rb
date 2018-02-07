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

    # Bouton retour pour les pages crédits et cQuoi
    @btn_retour = Bouton.new(self, "Retour", 550, 7)


    # Booléens pour les pages
    @bool_jouer = false
    @bool_credit = false
    @bool_cQuoi = false
    @bool_quitter = false
    @bool_menu = true

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
    @cquoi = Cquoi.new(self, "
                                          NOMDUJEU est un Die 'N Retry.

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

    if @btn_jouer.isClick
      @bool_menu = false
      @bool_jouer = true
    end
    if @btn_credit.isClick
      @bool_quitter = false
      @bool_jouer = false
      @bool_menu = false
      @bool_cQuoi = false
      @bool_credit = true
    end
    if @btn_cQuoi.isClick
      @bool_credit = false
      @bool_quitter = false
      @bool_jouer = false
      @bool_menu = false
      @bool_cQuoi = true
    end
    if @btn_quitter.isClick
      @bool_quitter = true
    end
    if @btn_retour.isClick
      @bool_jouer = false
      @bool_credit = false
      @bool_cQuoi = false
      @bool_menu = true
    end

    puts "#{@bool_jouer} #{@bool_quitter} #{@bool_cQuoi} #{@bool_credit} #{@bool_menu} "
    #puts @bool_credit
    #puts @bool_menu
    #puts @bool_quitter
    #puts @bool_jouer

    if @bool_credit
      credit
    elsif @bool_cQuoi
      cQuoi
    elsif @bool_jouer
      a = Game.new
    elsif @bool_menu
      menu
    elsif @bool_quitter
      abort("REVIENS")
      exit
    end

  end


  def cQuoi
    fond
    @cquoi.draw
    @btn_retour.draw
  end

  def credit
    fond
    @credit.draw
    @btn_retour.draw
  end

  def menu
    fond
    @btn_jouer.draw
    @btn_credit.draw
    @btn_cQuoi.draw
    @btn_quitter.draw
  end

  def fond
    @curseur.draw(mouse_x ,mouse_y, 30)
    @bg.draw(0, 0, -10)
  end
end
