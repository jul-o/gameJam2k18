require_relative 'Bouton'
require_relative 'Credits'
require_relative 'Cquoi'

class Menu < Gosu::Window

  # Dimension fenêtre du menu
  @@WIDTH = 1200
  @@HEIGHT = 700

  # Animation marrante
  DUREE_ANIMATION_COMPLETE_MS = 300
  VELOCITY_H = 4
  REFOCUS_TIME = 400
  FOCUS_FRAMES = 4
  
  def initialize
    @nom = "Castle Invaders"

    # Définition des boutons
    @btn_jouer = Bouton.new(self, "jouer", 240, 0)
    @btn_credit = Bouton.new(self, "credits", 310 + 20, 0)
    @btn_cQuoi = Bouton.new(self, "buts", 400 + 20, 0)

    # Bouton retour pour les pages crédits et cQuoi
    @btn_retour = Bouton.new(self, "retour", 550, 7)

    # Booléens pour les pages
    @bool_jouer = false
    @bool_credit = false
    @bool_cQuoi = false
    @bool_quitter = false
    @bool_retour_Menu = false
    @bool_menu = true

    @bg = Gosu::Image.new("resources/menu/bgMenu.png")
    @curseur = Gosu::Image.new("resources/menu/curseur.png")

    # Animation du seul mob cool du jeu
    allSrc =
    ["resources/sprites/aliens/bossR/spriteBoss1G.png",
    "resources/sprites/aliens/bossR/spriteBoss2G.png",
    "resources/sprites/aliens/bossR/spriteBoss3G.png",
    "resources/sprites/aliens/bossR/spriteBoss4G.png",
    "resources/sprites/aliens/bossR/spriteBoss5G.png",
    "resources/sprites/aliens/bossR/spriteBoss6G.png",
    "resources/sprites/aliens/bossR/spriteBoss7G.png",
    "resources/sprites/aliens/bossR/spriteBoss8G.png",
    "resources/sprites/aliens/bossR/spriteBoss9G.png",
    "resources/sprites/aliens/bossR/spriteBoss10G.png",
    "resources/sprites/aliens/bossR/spriteBoss11G.png"]
    @allSp = []

    allSrc.each do |src|
      @allSp << Gosu::Image.new(src, :retro=>true)      
    end

    @imgFocus = Gosu::Image.new('resources/menu/anim/focus.png')

    @currentIm = @allSp[0]
    @iSCourant = 0
    @dateMajSprite = 0.0

    # => effet de refocus :
    @offsetX,@offsetY = rand(1..15), rand(1..15)
    @timerRefocus = 0.0

    @posX = -120 # position de départ
    @focus = [0,0]
    @focusFrames = 0
    @refocus = false
    # ===

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

    # Update de l'animation cool
    if (Gosu.milliseconds > @dateMajSprite + DUREE_ANIMATION_COMPLETE_MS/@allSp.length)
      @iSCourant += 1
      @currentIm = @allSp[@iSCourant % @allSp.length]
      @dateMajSprite = Gosu.milliseconds
    end
    # => effet de focus :
    if (Gosu.milliseconds > @timerRefocus + REFOCUS_TIME)
      @offsetX,@offsetY = (rand(1..240)- 120), (rand(1..40)-20)
      @timerRefocus = Gosu.milliseconds
    else
      @focusFrames += 1
      # On décide s'il est nécessaire de se déplacer à cette frame
      if (@focusFrames >= FOCUS_FRAMES) then
        @refocus = true
        @focusFrames = 0
      end
    end
    # ==
  end

  def draw
    if @btn_jouer.isClick
      @bool_quitter = false
      @bool_menu = false
      @bool_cQuoi = false
      @bool_credit = false
      @bool_jouer = true

      sleep 0.2
    end
    if @btn_credit.isClick
      # @bool_quitter = false
      # @bool_jouer = false
      # @bool_menu = false
      # @bool_cQuoi = false
      # @bool_credit = true      
    end
    if @btn_cQuoi.isClick
      # @bool_credit = false
      # @bool_quitter = false
      # @bool_jouer = false
      # @bool_menu = false
      # @bool_cQuoi = true
    end
    if @btn_retour.isClick && @bool_jouer = false
      @bool_cQuoi = false
      @bool_credit = false
      @bool_retour_Menu = true
    end

    if @bool_menu
      menu
    end

    # Dessin de l'animation sympatoche
    @posX += VELOCITY_H

    # => dessin du focus en fond
    # calcul de la position du focus
    if (@refocus) then
      if (@focus[0]<@offsetX) 
        @focus[0] += 1 
      else
        @focus[0] -= 1
      end
      if (@focus[1]<@offsetY) 
        @focus[1] += 1 
      else
        @focus[1] -= 1
      end
      @refocus = false
    end

    @imgFocus.draw @posX%@@WIDTH-47+@focus[0],555-14+@focus[1],1,1,1

    # => dessin de l'image
    @currentIm.draw @posX%@@WIDTH,555,1,6,6
  end

  def menu
    fond
    @btn_jouer.draw
    @btn_credit.draw
    @btn_cQuoi.draw
  end


  def fond
    @curseur.draw(mouse_x ,mouse_y, 30)
    @bg.draw(0, 0, -10)
  end

end