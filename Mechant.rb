require_relative 'Personnage'

# Définit les différents types de mobs
# Format : sizeX, sizeY, spriteGauche, spriteDroit
module AlienType
  CANARD_BLEU = [35, 35, "resources/sprites/alienBD.png", "resources/sprites/alienBG.png"]
end

class Mechant < Personnage

  SPRITE_GAUCHE = "resources/sprites/alienBG.png"
  SPRITE_DROITE = "resources/sprites/alienBD.png"

  VELOCITY_M = 5

  def initialize (map, x , y, size_x = 35, size_y = 50)
    @sizeX = size_x
    @sizeY = size_y

    @vX = VELOCITY_M
    @vY = 0
    @frameJump = 0

    super map, x, y, VELOCITY_M, @sizeX, @sizeY, SPRITE_GAUCHE, SPRITE_DROITE
  end

  def draw
    super
  end

  def move
    super
    # Après l'appel de super.move() si vX est à 0 ca signifie qu'on est bloqué
    # Il faut donc repartir dans l'autre direction, et le seul moyen c'est de récuperer son orientation
    if (@vX == 0)
      if @tourneVersDroite
        @vX = -VELOCITY_M
        @tourneVersDroite = false
      else
        @vX = VELOCITY_M
        @tourneVersDroite = true
      end
    end
  end

  def tourner
    @tourneVersDroite = !@tourneVersDroite
    @vX = -@vX
  end


end