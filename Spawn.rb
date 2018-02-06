class Spawn
  attr_reader :x, :y, :nbMechants

  def initialize x, y, nbMechants
    @x = x
    @y = y
    @nbMechants = nbMechants
    # todo : afficher l'image du spawn
  end

  def tick
    if (20*rand).to_i == 1 then
      # todo : faire apparaitre un monstre en @x, @y
    end
  end
end