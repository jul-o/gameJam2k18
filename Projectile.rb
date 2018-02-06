class Projectile
        
    # Constantes de classe
    SIZE_X = 15
    SIZE_Y = 15

    # Vélocité
    VELOCITY_P = 20

    attr_reader :x, :y

    def initialize gun,id,x,y,tourneDroite,sprite,rY 
        # rY => radius de projection des balles
        @vY = rand(-rY..rY)

        @x = x
        @y = y
        @tourneDroite = tourneDroite
        @gun = gun

        # Sprite du projectile
        @spriteT = sprite

        # Calcul des ratios x\y
        @ratioX = SIZE_X.to_f/15
        @ratioY = SIZE_Y.to_f/15
        
        # Vélocité courante
        @vX = VELOCITY_P

        # Indice
        @id = id

        # On récupère l'instance de map
        @map = Map.INST
    end

    def draw
        @spriteT.draw @x,@y, 0, @ratioX, @ratioY       
    end

    def update
        @vX *= 0.95
        @vY *= 0.95

        # On vérifie s'il y a collision
        # Droite\Gauche    
        if ((
            (@map.obstAt_Project?([@x+@vX,@y])) or (!((0..(Game.WIDTH - SIZE_X))===(@x + @vX)))
            )
        ) or (
            (@map.obstAt_Project?([@x,@vY+@y])) or (!((0..(Game.HEIGHT - SIZE_Y))===(@y + @vY)))
            ) then

            @vX = 0
            @vY = 0

            # Il faut retirer le projectile de la liste des trucs
            @gun.deleteProj(@id)
        end

        if @tourneDroite then
            # +=
            @x += @vX + VELOCITY_P/4
        else
            @x -= @vX + VELOCITY_P/4
        end

        @y += @vY
    end

    def self.SIZE
        [SIZE_X, SIZE_Y]
    end
end