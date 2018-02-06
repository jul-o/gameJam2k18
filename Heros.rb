require_relative 'Personnage'
require_relative 'Map'

class Heros < Personnage
  attr_reader :img

  # Constantes de classe
  NB_FRAME_JUMP = 30

  SIZE_X = 37
  SIZE_Y = 50

  SPRITE_GAUCHE = "resources/marioG.png"
  SPRITE_DROITE = "resources/marioD.png"

  VELOCITY_H = 8

  def initialize map, x, y
    @sizeX = SIZE_X
    @sizeY = SIZE_Y

    @vX = 0
    @vY = 0
    @frameJump = 0

    super map, x, y, VELOCITY_H, @sizeX, @sizeY, SPRITE_GAUCHE, SPRITE_DROITE
  end

  def draw
    super
    testJump
  end

  def testJump
    if @jumping
      @frameJump +=1

      if @frameJump < NB_FRAME_JUMP/2
        r = -(@frameJump - NB_FRAME_JUMP/2)/((NB_FRAME_JUMP.to_f/2))
        @vY = -r*VELOCITY_H*3
      elsif @frameJump < NB_FRAME_JUMP
        r = (@frameJump - NB_FRAME_JUMP/2)/((NB_FRAME_JUMP.to_f/2))
        @vY =  r*VELOCITY_H*3
      else
        @vY = 0
        @jumping = false
        @frameJump = 0
      end
    end
  end

  def jump
    @jumping = true
  end

  def self.SIZE
    return [SIZE_X, SIZE_Y]
  end
end