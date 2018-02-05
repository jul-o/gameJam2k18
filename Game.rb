class Game < Gosu::Window

  # Dimensions map : 24x14

  def initialize
    @WIDTH = 1440
    @HEIGHT = 920
    @NOM = "GameJam"

    super @WIDTH, @HEIGHT

    self.caption = @NOM

    self.show
  end
end