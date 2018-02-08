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
    @bool_retour_Menu = false
    @bool_menu = true


    @bg = Gosu::Image.new("resources/bg2.jpg")
    @curseur = Gosu::Image.new("resources/curseur.png")

    super @@WIDTH, @@HEIGHT, options = {:fullscreen => false}
    self.caption = @nom
    self.show
  end

  def update
    if @bool_jouer
      close
      $game = Game.new.show
    end
    if @bool_quitter
      exit
    end
    if @bool_cQuoi
      close
      $cQuoi = Cquoi.new.show
    end
    if @bool_retour_Menu
      close
      $menu = Menu.new.show
    end
    if @bool_credit
      close
      $credit = Credits.new.show
    end
  end

  def draw
    if @btn_jouer.isClick
      @bool_quitter = false
      @bool_menu = false
      @bool_cQuoi = false
      @bool_credit = false
      @bool_jouer = true

      sleep 0.1
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
      @bool_cQuoi = false
      @bool_credit = false
      @bool_retour_Menu = true
    end

    if @bool_menu
      menu
    end
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
