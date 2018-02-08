require_relative 'Personnage'

# Définit les différents types de mobs
# Format :      0  -   1  -      2      -     3      -    4   -    5
#             sizeX, sizeY, spriteDroit, spriteGauche,  pvMax,  vélocité
module AlienType
  CANARD_VERT =   [35, 50, ["resources/sprites/aliens/AlienVertD1.png", "resources/sprites/aliens/AlienVertD2.png"],
                   ["resources/sprites/aliens/AlienVertG1.png",  "resources/sprites/aliens/AlienVertG2.png"], 30, 5]
  CANARD_ROUGE =  [35, 50,  ["resources/sprites/aliens/AlienRougeD1.png", "resources/sprites/aliens/AlienRougeD2.png"],
                            ["resources/sprites/aliens/AlienRougeG1.png", "resources/sprites/aliens/AlienRougeG2.png"], 30,5]
  CANARD_VIOLET = [35, 50,  ["resources/sprites/aliens/AlienVioletD1.png", "resources/sprites/aliens/AlienVioletD2.png"],
                            ["resources/sprites/aliens/AlienVioletG1.png", "resources/sprites/aliens/AlienVioletG2.png"], 30,5]
  SLIME_BLEU    = [50, 50,  ["resources/sprites/slime/slimeD1.png",
                             "resources/sprites/slime/slimeD2.png",
                             "resources/sprites/slime/slimeD3.png",
                             "resources/sprites/slime/slimeD4.png",
                             "resources/sprites/slime/slimeD5.png",
                             "resources/sprites/slime/slimeD6.png"],
                            ["resources/sprites/slime/slimeG1.png",
                             "resources/sprites/slime/slimeG2.png",
                             "resources/sprites/slime/slimeG3.png",
                             "resources/sprites/slime/slimeG4.png",
                             "resources/sprites/slime/slimeG5.png",
                             "resources/sprites/slime/slimeG6.png"], 40, 3]

  SLIME_BLEU_BOSS    = [100, 100,  ["resources/sprites/slime/slimeD1.png",
                             "resources/sprites/slime/slimeD2.png",
                             "resources/sprites/slime/slimeD3.png",
                             "resources/sprites/slime/slimeD4.png",
                             "resources/sprites/slime/slimeD5.png",
                             "resources/sprites/slime/slimeD6.png"],
                             ["resources/sprites/slime/slimeG1.png",
                              "resources/sprites/slime/slimeG2.png",
                              "resources/sprites/slime/slimeG3.png",
                              "resources/sprites/slime/slimeG4.png",
                              "resources/sprites/slime/slimeG5.png",
                              "resources/sprites/slime/slimeG6.png"], 200, 3]

  # Variables pratiques
  NBMOBS = 4
  NBBOSSES = 1
  ALLMOBS = [SLIME_BLEU, CANARD_VIOLET, CANARD_ROUGE, CANARD_VERT, SLIME_BLEU_BOSS] #les boss doivent etre déclarés après les mobs classiques

  # Génère un mob au hasard et renvoie ses propriétés
  def self.RND
    ALLMOBS[rand (0..NBMOBS-1)]
  end

  def self.RND_BOSS
    ALLMOBS[rand (NBMOBS..NBBOSSES - 1 + NBMOBS)]
  end
end

class Mechant < Personnage

  # VELOCITY_M = 5

  def initialize (typeMob, map, x , y)
    @velocity = typeMob[5]
    @sizeX = typeMob[0]
    @sizeY = typeMob[1]

    #?=
    # SUPPRIMER CES 2 LIGNES
    @spriteD = typeMob[2]
    @spriteG = typeMob[3]
    #?=

    @pV = typeMob[4]

    @vX = typeMob[5]
    @vY = 0

    @frameJump = 0

    #?=
    super map, x, y, @vX, @sizeX, @sizeY, @spriteG, @spriteD
    #?=
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