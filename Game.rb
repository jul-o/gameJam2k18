class Game < Gosu::Window

  def initialize

    @WIDTH = 1440
    @HEIGHT = 920
    @NOM = "le nom du jeu"


    super @WIDTH, @HEIGHT, options = {:fullscreen => true}

    self.caption = @NOM

    self.show
  end
end