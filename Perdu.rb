include Gosu

require_relative 'Bouton'
require_relative 'Menu'

class Perdu < Window


  # Dimension fenêtre du menu
  @@WIDTH = 1200
  @@HEIGHT = 700

  def initialize
    @text = Image.from_text("VOUS AVEZ PERDU !", 40, :font => "resources/retroComputer.ttf", :width => 1200, :align => :center)
    @nbBalles = Image.from_text("Balles touchees : #{Game.INSTANCE.score?[4]}", 40, :font => "resources/retroComputer.ttf", :width => 1200, :align => :center)
    @score = Image.from_text("SCORE = #{Game.INSTANCE.score?[3]}", 40, :font => "resources/retroComputer.ttf", :width => 1200, :align => :center)
    @nbCaissesTotal = Image.from_text("Caisses totales : #{Game.INSTANCE.score?[2]}", 40, :font => "resources/retroComputer.ttf", :width => 1200, :align => :center)
    @nbEnnemisPasses = Image.from_text("Aliens enfuis : #{Game.INSTANCE.score?[1]}", 40, :font => "resources/retroComputer.ttf", :width => 1200, :align => :center)
    @nbMobsTues = Image.from_text("Aliens tues : #{Game.INSTANCE.score?[0]}", 40, :font => "resources/retroComputer.ttf", :width => 1200, :align => :center)
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
    @text.draw(0, 140, 10, 1, 1, Color.argb(255, 255, 255, 255))
    @score.draw(0, 250, 10, 1, 1, Color.argb(255, 255, 175, 0))
    @nbCaissesTotal.draw(0, 300, 10, 1, 1, Color.argb(255, 168, 255, 0))
    @nbEnnemisPasses.draw(0, 350, 10, 1, 1, Color.argb(255, 255, 0, 216))
    @nbBalles.draw(0, 400, 10, 1, 1, Color.argb(255, 75, 255, 235))
    @nbMobsTues.draw(0, 450, 10, 1, 1, Color.argb(255, 180, 30, 205))
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