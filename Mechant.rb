require_relative 'Personnage'
require_relative 'particles/BlinkEffect'

# Définit les différents types de mobs
# Format :      0  -   1  -      2      -     3      -    4   -    5   -    6     -     7
#             sizeX, sizeY, spriteDroit, spriteGauche,  pvMax,  vélocité, typePers, vélocitéBase
module AlienType
  CANARD_VERT =   [35, 50, ["resources/sprites/aliens/AlienVertD1.png", "resources/sprites/aliens/AlienVertD2.png"],
                   ["resources/sprites/aliens/AlienVertG1.png",  "resources/sprites/aliens/AlienVertG2.png"], 100, 3, TYPE_MONSTRE, 3]
  CANARD_ROUGE =  [35*0.7, 50*0.7,  ["resources/sprites/aliens/AlienRougeD1.png", "resources/sprites/aliens/AlienRougeD2.png"], #35.50
                            ["resources/sprites/aliens/AlienRougeG1.png", "resources/sprites/aliens/AlienRougeG2.png"], 100,3, TYPE_MONSTRE, 3]
  CANARD_VIOLET = [35, 50,  ["resources/sprites/aliens/AlienVioletD1.png", "resources/sprites/aliens/AlienVioletD2.png"],
                            ["resources/sprites/aliens/AlienVioletG1.png", "resources/sprites/aliens/AlienVioletG2.png"], 200,1, TYPE_MONSTRE, 3]
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
                             "resources/sprites/slime/slimeG6.png"], 30, 7, TYPE_MONSTRE, 3]

  SLIME_BLEU_BOSS    = [100, 100,  ["resources/sprites/aliens/bossV/spriteBoss1G.png",
  "resources/sprites/aliens/bossV/spriteBoss2G.png",
  "resources/sprites/aliens/bossV/spriteBoss3G.png",
  "resources/sprites/aliens/bossV/spriteBoss4G.png",
  "resources/sprites/aliens/bossV/spriteBoss5G.png",
  "resources/sprites/aliens/bossV/spriteBoss6G.png",
  "resources/sprites/aliens/bossV/spriteBoss7G.png",
  "resources/sprites/aliens/bossV/spriteBoss8G.png",
  "resources/sprites/aliens/bossV/spriteBoss9G.png",
  "resources/sprites/aliens/bossV/spriteBoss10G.png",
  "resources/sprites/aliens/bossV/spriteBoss11G.png"],

  ["resources/sprites/aliens/bossV/spriteBoss1D.png",
  "resources/sprites/aliens/bossV/spriteBoss2D.png",
  "resources/sprites/aliens/bossV/spriteBoss3D.png",
  "resources/sprites/aliens/bossV/spriteBoss4D.png",
  "resources/sprites/aliens/bossV/spriteBoss5D.png",
  "resources/sprites/aliens/bossV/spriteBoss6D.png",
  "resources/sprites/aliens/bossV/spriteBoss7D.png",
  "resources/sprites/aliens/bossV/spriteBoss8D.png",
  "resources/sprites/aliens/bossV/spriteBoss9D.png",
  "resources/sprites/aliens/bossV/spriteBoss10D.png",
  "resources/sprites/aliens/bossV/spriteBoss11D.png"], 500, 3, TYPE_BOSS, 3]

  SLIME_VERT_BOSS    = [100, 100,  ["resources/sprites/aliens/bossR/spriteBoss1G.png",
                            "resources/sprites/aliens/bossR/spriteBoss2G.png",
                            "resources/sprites/aliens/bossR/spriteBoss3G.png",
                            "resources/sprites/aliens/bossR/spriteBoss4G.png",
                            "resources/sprites/aliens/bossR/spriteBoss5G.png",
                            "resources/sprites/aliens/bossR/spriteBoss6G.png",
                            "resources/sprites/aliens/bossR/spriteBoss7G.png",
                            "resources/sprites/aliens/bossR/spriteBoss8G.png",
                            "resources/sprites/aliens/bossR/spriteBoss9G.png",
                            "resources/sprites/aliens/bossR/spriteBoss10G.png",
                            "resources/sprites/aliens/bossR/spriteBoss11G.png"],

                            ["resources/sprites/aliens/bossR/spriteBoss1D.png",
                            "resources/sprites/aliens/bossR/spriteBoss2D.png",
                            "resources/sprites/aliens/bossR/spriteBoss3D.png",
                            "resources/sprites/aliens/bossR/spriteBoss4D.png",
                            "resources/sprites/aliens/bossR/spriteBoss5D.png",
                            "resources/sprites/aliens/bossR/spriteBoss6D.png",
                            "resources/sprites/aliens/bossR/spriteBoss7D.png",
                            "resources/sprites/aliens/bossR/spriteBoss8D.png",
                            "resources/sprites/aliens/bossR/spriteBoss9D.png",
                            "resources/sprites/aliens/bossR/spriteBoss10D.png",
                            "resources/sprites/aliens/bossR/spriteBoss11D.png"], 500, 3, TYPE_BOSS, 3]

  # Variables pratiques
  NBMOBS = 4
  NBBOSSES = 1
  ALLMOBS = [SLIME_BLEU, CANARD_VIOLET, CANARD_ROUGE, CANARD_VERT, SLIME_BLEU_BOSS, SLIME_VERT_BOSS] #les boss doivent etre déclarés après les mobs classiques

  # Génère un mob au hasard et renvoie ses propriétés
  def self.RND
    ALLMOBS[rand (0..NBMOBS-2)]
  end

  def self.RND_BOSS
    ALLMOBS[rand (4..5)]
  end

end

class Mechant < Personnage

  # VELOCITY_M = 5
  attr_reader :estBoss

  ID_SON_MORT_BOSS = 6
  ID_SON_SPAWN_MONSTRE_NORMAUX = 0

  def initialize (typeMob, map, x , y, game)
    @game = game
    @accelere = false
    @typePers = typeMob[6]
    @velocity = typeMob[5]
    @sizeX = typeMob[0]
    @sizeY = typeMob[1]

    @spriteD = typeMob[2]
    @spriteG = typeMob[3]
    @estBoss = typeMob[6]

    @pV = typeMob[4]

    @vX = typeMob[5]
    @vY = 0

    @frameJump = 0

    # Bruit spawn
    Son.INST.playSon(ID_SON_SPAWN_MONSTRE_NORMAUX)

    super map, x, y, @vX, @sizeX, @sizeY, @spriteG, @spriteD, typeMob[6]
  end

  def draw shakex, shakeY
    super shakex, shakeY
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
      @mobDying = true
      # Game.INSTANCE.removeMob self

      if isDead && @typePers == TYPE_BOSS && !@accelere
          puts @typePers
          @game.accelerer
          @accelere = true
      end

      if @typePers == TYPE_BOSS
        Son.INST.playSon(ID_SON_MORT_BOSS)
      end
    end


    # On lance l'animation de clignotement du mob
    blink
  end

  def isDead
    @pV <= 0
  end

  def isEscaped
    @escaped
  end
end
