require_relative 'Personnage'

# Définit les différents types de mobs
# Format :      0  -   1  -      2      -     3      -    4   -    5
#             sizeX, sizeY, spriteGauche, spriteDroit, pvMax,   vélocité
module AlienType
  CANARD_BLEU = [35, 50, "resources/sprites/alienBD.png", "resources/sprites/alienBG.png",10,5]

  # Variables pratiques
  NBMOBS = 1
  ALLMOBS = [CANARD_BLEU]

  # Génère un mob au hasard et renvoie ses propriétés
  def self.RND
    ALLMOBS[rand (0..NBMOBS-1)]
  end
end

class Mechant < Personnage

  # SPRITE_GAUCHE = "resources/sprites/alienBG.png"
  # SPRITE_DROITE = "resources/sprites/alienBD.png"

  # VELOCITY_M = 5

  def initialize (typeMob, map, x , y)
    @velocity = typeMob[5]
    @sizeX = typeMob[0]
    @sizeY = typeMob[1]

    @spriteD = typeMob[2]
    @spriteG = typeMob[3]

    @pV = typeMob[4]

    @vX = typeMob[5]
    @vY = 0

    @frameJump = 0

    super map, x, y, @vX, @sizeX, @sizeY, @spriteG, @spriteD
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
        @vX = -@velocity
        @tourneVersDroite = false
      else
        @vX = @velocity
        @tourneVersDroite = true
      end
    end
  end

  def tourner
    @tourneVersDroite = !@tourneVersDroite
    @vX = -@vX
  end

  # Inflige des dégâts au monstre
  def dealDMG value
    @pV -= value

    # Si le mob est mort après l'attaque, on lance l'animation de mort
    if isDead then
      Game.INSTANCE.removeMob self
      # Pour l'instant il ne fait que disaparaître => à faire
    end
  end

  def isDead
    @pV <= 0
  end
end