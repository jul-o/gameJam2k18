require_relative 'Personnage'

class Heros < Personnage
  attr_reader :img

  # Constantes de classe
  NB_FRAME_JUMP = 30
  SPRITE_GAUCHE = "resources/marioG.png"
  SPRITE_DROITE = "resources/marioD.png"

  VELOCITY_H = 8

  def initialize map, x, y
    @sizeX = 50
    @sizeY = 50

    @velocityX = 0
    @velocityY = 0
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
        @velocityY = -r*VELOCITY_H*2
      elsif @frameJump < NB_FRAME_JUMP        
        r = (@frameJump - NB_FRAME_JUMP/2)/((NB_FRAME_JUMP.to_f/2))
        @velocityY =  r*VELOCITY_H*2
      else
        @velocityY = 0
        @jumping = false
        @frameJump = 0
      end
    end
  end

  def jump
    @jumping = true
  end
end